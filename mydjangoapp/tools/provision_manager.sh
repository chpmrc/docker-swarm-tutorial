#!/usr/bin/env bash

source .env

# Create Swarm cluster
docker swarm init --advertise-addr ${SWARM_MANAGER_IP_ADDR}

# Create overlay network to let services communicate
docker network create -d overlay ${SWARM_NETWORK}

# Run private registry
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# Set the registry as insecure (no authentication, only available to local network)
cat | sudo tee /etc/docker/daemon.json <<DOCKERCONFIG
{
  "insecure-registries": ["${SWARM_MANAGER_IP_ADDR}:5000"]
}
DOCKERCONFIG
sudo /etc/init.d/docker restart
