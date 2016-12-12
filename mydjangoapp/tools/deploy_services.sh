#!/usr/bin/env bash

# THIS SHOULD BE RUN ON THE SWARM MANAGER

source .env

# Assumptions:
# - The local registry is running
# - The cluster is created
# - The overlay network is created

# docker network create -d overlay mydjangoapp_net

# Regenerate TLS certificates if the public IP address of a node changed

# docker-machine regenerate-certs -f ${DOCKER_MACHINE_NAME}

# Build image

docker build -t mydjangoapp_web -f Dockerfile .

# Push to private registry

#docker login ${SWARM_MANAGER_IP_ADDR}:5000
docker tag mydjangoapp_web ${SWARM_MANAGER_IP_ADDR}:5000/mydjangoapp_web
docker push ${SWARM_MANAGER_IP_ADDR}:5000/mydjangoapp_web

# Create services (use `update` if not first deployment)

# Optional: Portainer
# docker run -d -p 9000:9000 -v ~/.docker/machine/certs:/certs portainer/portainer -H tcp://$(docker-machine ip smanager):3376 --tlsverify
docker service create \
    --name portainer \
    --publish 9000:9000 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    portainer/portainer \
    --swarm

docker service create \
    --publish 5432:5432 \
    --network ${SWARM_NETWORK} \
    --name db \
    --env POSTGRES_DB="${POSTGRES_DB}" \
    --env POSTGRES_USER="${POSTGRES_USER}" \
    --env POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
    mdillon/postgis

docker service create \
    --publish 8000:8000 \
    --network ${SWARM_NETWORK} \
    --name web \
    --env DJANGO_SECRET_KEY="${DJANGO_SECRET_KEY}" \
    --env DJANGO_SETTINGS_MODULE="${DJANGO_SETTINGS_MODULE}" \
    --env POSTGRES_DB="${POSTGRES_DB}" \
    --env POSTGRES_USER="${POSTGRES_USER}" \
    --env POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
    ${SWARM_MANAGER_IP_ADDR}:5000/mydjangoapp_web \
    python manage.py runserver 0:8000

# Utils

# Run a container with the same network namespace as the given container
# docker run --it --net=container:{http-service-container-id} ubuntu bash