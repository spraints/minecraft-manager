# Minecraft manager

This app manages my [mc-router](https://github.com/itzg/mc-router) instance.

- [x] Manage admin users.
    - Create in console (`u = User.new; u.email = "..."; u.password = "..."; u.password_confirmation = "..."; u.save`).
- [x] Manage a list of servers.
    - A server has a backend host:port and a frontend name.
    - A server can be archived, but only if it's not enabled in the current configuration.
- [x] Manage current configuration.
    - Configuration is a list of active servers.
    - Configuration can be in one of several states: proposed, queued, applied.
    - Active configuration is the "applied" version with the highest number.
    - From the current configuration, activating / deactivating generates a new proposed config.
    - Configuration versions are shown like an audit log.
- [x] Apply new configuration.
    1. Only one at a time.
    1. Check that it's not superceded.
    1. Generate a file on disk. File location is configured in docker-compose env.
    1. mc-router is running with [`-routes-config-watch`](https://github.com/itzg/mc-router/tree/main?tab=readme-ov-file#routing-configuration) and autoreloads it.
- [ ] Expose webhook activity.
    - [payload](https://github.com/itzg/mc-router/tree/main?tab=readme-ov-file#webhook-support).
    - Add backend-specific events to `minecraft_worlds#show`.
    - Add global events to `configurations#index`.
- [ ] Some other [queue backend](https://api.rubyonrails.org/v8.1.1/classes/ActiveJob/QueueAdapters.html).
- [ ] Audit log
    - Fill in table `ConfigurationActivity`.
- [ ] Live reload of homepage (`configurations#index`) and activity.

## Deployment

`compose.yaml` has an example deployment.

## Future ideas

- Manage minecraft servers too.
    - Maybe continue using tmux-based thing we're using.
    - Hook into mc-router's scale-to-zero feature so we can do the same.
- Use [migration plugin](https://railsatscale.com/2025-12-08-swappable-migration-backends-in-rails/) to do skeema or similar schema diff migrations.
