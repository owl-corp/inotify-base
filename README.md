# inotify-base

A slim image allowing for quick and easy webhooking on configuration/other file
changes.

This can be used as a sidecar container in Kubernetes/Docker/container based
applications to trigger certain HTTP webhook/other commands upon a change to a
mounted file/folder.

## Configuration

| Variable                  | Description                                                                                                                                                      | Default        |
|---------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|
| `INOTIFY_HOOK_SCRIPT`     | The executable to run on a change, as a path mounted on the filesystem                                                                                           | None           |
| `INOTIFY_WATCH_EVENTS`    | The types of events to listen for as a comma separated list, for example `delete,move`. A full list of events is available on the [inotifywait manpage][manpage] | All events     |
| `INOTIFY_WATCH_DIRECTORY` | The directory to watch for changes in, all subdirectories are recursively watched.                                                                               | `/opt/monitor` |
| `INOTIFY_HOOK_DELAY`      | A delay (in seconds) to wait before executing a hook, also acts as a debounce cooldown to prevent multiple events within a timespan                              | No delay       |

[manpage]: https://linux.die.net/man/1/inotifywait

It is recommended to mount your `INOTIFY_HOOK_SCRIPT` in a location that is not
used by any other aspect of the container, for example, mounting to
`/opt/owl-corp/` and using `/opt/owl-corp/hook.sh` as your `INOTIFY_HOOK_SCRIPT`
option.

> [!WARNING] 
> 
> By default, `inotifywait` will notify on *all* file events, this includes
> things like reading directories and opening files.
>
> It is highly recommended to refer to the above mentioned [inotifywait
> manpage][manpage] for the full list of events to narrow down to those which
> only modify a file in the ways you specifically wish to observe.


## Usage

A Docker compose file using this image might look like the following:

``` yaml
services:
  notifier:
    image: "ghcr.io/owl-corp/inotify-base:latest"
    volumes:
    - type: bind
      source: ./config
      target: /opt/monitor
    - type: bind
      source: ./scripts
      target: /opt/owl-corp
    environment:
      INOTIFY_HOOK_SCRIPT: /opt/owl-corp/script.sh
```

This will watch for all configuration changes in the local filesystem `config`
directory and execute the `script.sh` file in the local `scripts` directory.

## License

MIT License.
