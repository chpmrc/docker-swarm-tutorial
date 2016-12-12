# Create Consul instance for discovery

docker-machine create -d virtualbox mh-keystore

eval "$(docker-machine env mh-keystore)"

docker run -d \
	--restart=always \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

# Create manager

docker-machine create -d virtualbox \
    --swarm \
    --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  master

# Create workers

for i in $(seq 1); do
	docker-machine create -d virtualbox \
		--swarm \
		--swarm-discovery="consul://$(docker-machine ip mh-keystore):8500" \
		--engine-opt="cluster-store=consul://$(docker-machine ip mh-keystore):8500" \
		--engine-opt="cluster-advertise=eth1:2376" \
	worker${i}
done