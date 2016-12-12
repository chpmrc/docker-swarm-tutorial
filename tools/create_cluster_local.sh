#!/bin/bash

docker swarm init --advertise-addr localhost

# Note IP address of manager
echo "# Auto-generated\nexport SWARM_MANAGER_IP_ADDR=$(docker-machine ip manager)" >> .env

# Regenerate TLS certificates if the public IP address of a node changed
# docker-machine regenerate-certs -f ${DOCKER_MACHINE_NAME}