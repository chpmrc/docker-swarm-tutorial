#!/usr/bin/env bash

source .env

# Create swarm network
docker network create --driver overlay --subnet=10.0.9.0/24 ${PROJECT_NAME}

# Optional: Portainer to manage the cluster
# docker run -d -p 9000:9000 -v ~/.docker/machine/certs:/certs portainer/portainer -H tcp://$(docker-machine ip smanager):3376 --tlsverify
docker service create \
    --name portainer \
    --publish 9000:9000 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    portainer/portainer --swarm

# Create directory for registry's cache
sudo mkdir -p /data

# Run private registry
docker service create \
    --name registry \
    --publish 5000:5000 \
    --constraint 'node.role == manager' \
    --env REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY='/data' \
    --mount type=bind,src=/var/cache,dst=/data \
    registry:2

# Set the registry as insecure (no authentication, only available to local network)
cat | sudo tee /etc/docker/daemon.json <<DOCKERCONFIG
{
  "insecure-registries": ["${SWARM_MANAGER_IP_ADDR}:5000"]
}
DOCKERCONFIG

# Restart docker to pick up new registry
sudo /etc/init.d/docker restart
