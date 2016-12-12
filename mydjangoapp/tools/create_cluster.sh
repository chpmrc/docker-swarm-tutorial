#!/bin/bash

# For EC2 use amazonec2

# docker-machine create --driver amazonec2 aws01

docker-machine create \
    -d virtualbox \
    smanager

for i in $(seq 2); do
	docker-machine create \
	    -d virtualbox \
	    sworker${i}
done
