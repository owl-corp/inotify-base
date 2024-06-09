#!/bin/bash

set -exo pipefail

if [ -z ${INOTIFY_HOOK_SCRIPT+x} ]; then
    echo "Missing INOTIFY_HOOK_SCRIPT environment variable, set it to the script to run upon file changes";
    exit 1;
else
    if ! test -f $INOTIFY_HOOK_SCRIPT; then
        echo "The file pointed to by INOTIFY_HOOK_SCRIPT does not exist, check your container mounts.";
        exit 1;
    fi;

    if ! test -x $INOTIFY_HOOK_SCRIPT; then
        echo "INOTIFY_HOOK_SCRIPT is not an executable file (missing +x bit), check file permissions of the hook script."
        exit 1;
    fi;
fi;

if [ -n "$INOTIFY_WATCH_EVENTS" ]; then
  ADDITIONAL_ARGS="-e $INOTIFY_WATCH_EVENTS"
else
  ADDITIONAL_ARGS=""
fi

if [ -n "$INOTIFY_WATCH_DIRECTORY" ]; then
  WATCH_DIR="$INOTIFY_WATCH_DIRECTORY"
else
  WATCH_DIR="/opt/monitor"
fi

while inotifywait $ADDITIONAL_ARGS -r $WATCH_DIR; do
    if [ ! -z ${INOTIFY_HOOK_DELAY+x} ]; then
        echo "Waiting $INOTIFY_HOOK_DELAY until executing hook..."
        sleep $INOTIFY_HOOK_DELAY
    fi
    $INOTIFY_HOOK_SCRIPT
done;
