#!/usr/bin/env bash

source .env

# Run private registry
sudo mkdir /data
docker service create \
    --name registry \
    --publish 5000:5000 \
    --constraint 'node.role == manager' \
    --env REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY='/data' \
    --mount type=bind,src=/data,dst=/data \
    registry:2

# Set the registry as insecure (no authentication, only available to local network)
cat | sudo tee /etc/docker/daemon.json <<DOCKERCONFIG
{
  "insecure-registries": ["${SWARM_MANAGER_IP_ADDR}:5000"]
}
DOCKERCONFIG
sudo /etc/init.d/docker restart
