#!/usr/bin/env bash

source .env

# Set the registry as insecure (no authentication, only available to local network)
cat | sudo tee /etc/docker/daemon.json <<DOCKERCONFIG
{
  "insecure-registries": ["${SWARM_MANAGER_IP_ADDR}:5000"]
}
DOCKERCONFIG

# Restart docker to pick up new registry
sudo /etc/init.d/docker restart
