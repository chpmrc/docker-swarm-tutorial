#!/usr/bin/env bash

source .env

# Set the registry as insecure (no authentication, only available to local network)
sed -e "s/\${SWARM_MANAGER_IP_ADDR}/${SWARM_MANAGER_IP_ADDR}/" config/daemon.json | sudo tee /etc/docker/daemon.json

# Restart docker to pick up new registry
sudo /etc/init.d/docker restart
