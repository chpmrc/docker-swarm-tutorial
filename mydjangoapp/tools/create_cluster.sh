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

# Create network

eval $(docker-machine env manager)

docker network create --driver overlay --subnet=10.0.9.0/24 swarmnet

# Optional: Portainer to manage the cluster
# docker run -d -p 9000:9000 -v ~/.docker/machine/certs:/certs portainer/portainer -H tcp://$(docker-machine ip smanager):3376 --tlsverify
docker service create \
    --name portainer \
    --publish 9000:9000 \
    --constraint 'node.role == manager' \
    --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
    portainer/portainer --swarm
