# Deployment and orchestration of containerized apps on swarm

## Steps

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

## Open questions

- How to get the project's source to the manager?
- Best way to export SSH credentials from docker machine?
- Share mounted volume across cluster instances?

## Notes

- Portainer does not support multi-host swarm, at the moment.