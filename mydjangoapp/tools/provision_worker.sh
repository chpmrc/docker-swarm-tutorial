#!/usr/bin/env bash

# Run command to join swarm cluster (from manager)

# Set the registry as insecure (no authentication, only available to local network)
cat | sudo tee /etc/docker/daemon.json <<DOCKERCONFIG
{
  "insecure-registries": ["${SWARM_MANAGER_IP_ADDR}:5000"]
}
DOCKERCONFIG
sudo /etc/init.d/docker restart
