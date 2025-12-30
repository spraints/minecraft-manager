# Minecraft manager

This app manages my [mc-router](https://github.com/itzg/mc-router) instance.

- [ ] Manage admin users.
- [ ] Manage a list of servers.
    - A server has a backend host:port and a frontend name.
    - A server can be archived, but only if it's not enabled in the current configuration.
- [ ] Manage current configuration.
    - Configuration is a list of active servers.
    - Configuration can be in one of several states: proposed, queued, applied.
    - Active configuration is the "applied" version with the highest number.
    - From the current configuration, activating / deactivating generates a new proposed config.
    - Configuration versions are shown like an audit log.
- [ ] Apply new configuration.
    1. Only one at a time.
    1. Check that it's not superceded.
    1. Generate a file on disk. File location is configured in docker-compose env.
    1. mc-router is running with [`-routes-config-watch`](https://github.com/itzg/mc-router/tree/main?tab=readme-ov-file#routing-configuration) and autoreloads it.
- [ ] Expose webhook activity.
    - [payload](https://github.com/itzg/mc-router/tree/main?tab=readme-ov-file#webhook-support).

## Deployment

`compose.yaml` has an example deployment.
