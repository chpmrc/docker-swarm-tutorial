# Deployment and orchestration of containerized apps on swarm

## Overview

- Create cluster nodes.
  - Note down IP address of manager.
- Provision manager.
- Provision workers.
- Deploy (insecure) registry.
- Build image.
- Push to registry.
- Deploy services.
- Scale services.
- Deploy Portainer.

## Setup

All the commands must be run from the project's root (i.e. where the `tools` folder and `.env` files are).

### Create a cluster

#### Local (single-node)

`source tools/create_cluster_local.sh`

#### Remote (multi-node)

`source tools/create_cluster_remote.sh`

**Note**: remember to change the driver and the number of nodes to suit your needs.

### Provision manager

#### Remote

SSH into the swarm manager, for example:

`docker-machine ssh manager`

Mount/copy the project's files to the swarm manager (e.g. clone the repository) and run:

`source tools/provision_manager.sh`

#### Local

`source tools/provision_manager.sh`

### Deploy services

`source tools/deploy_services.sh`

**Note**: remember to change the `deploy_services.sh` script to suit your needs.

## Solved questions

- How do I check the logs of a container?

There are two ways: if the container shows up in Portainer simply click on "Logs".
If it doesn't you should 1) identify the node on which the container is running (e.g. worker3), SSH into the node and run `docker logs ${CONTAINER_ID}`.

- How do I ssh into a container?

Read above but replace the final command with `docker exec -it ${CONTAINER_ID} sh`.

## Open questions

- Best way to export SSH credentials from docker machine (sharing with other devs)?
- Share mounted volume across cluster instances?

## Notes

- At the moment all services should be pinned to the manager with `--constraint 'node.role == manager'` (assuming there is only **one** manager) to have centralized logging/SSH in Portainer. This will be solved with Docker engine 1.13+.