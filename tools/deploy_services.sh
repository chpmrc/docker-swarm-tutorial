#!/usr/bin/env bash

# Note: this should be run on the swarm manager

source .env

# Assumptions:
# - The private registry is running
# - The cluster is created
# - The overlay network is created

# Build image

docker build -t mydjangoapp_web -f ${PROJECT_NAME}/Dockerfile ${PROJECT_NAME}

# Push to private registry

#docker login ${SWARM_MANAGER_IP_ADDR}:5000
docker tag mydjangoapp_web ${SWARM_MANAGER_IP_ADDR}:5000/mydjangoapp_web
docker push ${SWARM_MANAGER_IP_ADDR}:5000/mydjangoapp_web

# Create services (use `update` if not first deployment)

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