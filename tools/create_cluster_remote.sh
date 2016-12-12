#!/bin/bash

# For EC2 use -d amazonec2
# docker-machine create -d amazonec2 aws01

docker-machine create \
    -d virtualbox \
    manager

CMD=$(docker-machine ssh manager docker swarm init --advertise-addr $(docker-machine ip manager) | awk 'NR >=5 && NR <=7 {print
 $0}')

for i in $(seq 1); do
	docker-machine create \
	    -d virtualbox \
	    worker${i} && \
    docker-machine ssh worker${i} ${CMD}
done

# Note IP address of manager
echo "# Auto-generated\nexport SWARM_MANAGER_IP_ADDR=$(docker-machine ip manager)" >> .env

# Regenerate TLS certificates if the public IP address of a node changed
# docker-machine regenerate-certs -f ${DOCKER_MACHINE_NAME}