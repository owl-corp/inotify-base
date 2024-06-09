#!/usr/bin/env sh

set -exo pipefail

if [ -z ${HOOK_SCRIPT+x} ]; then
    echo "Missing HOOK_SCRIPT environment variable, set it to the script to run upon file changes";
    exit 1;
else
    if ! test -f $HOOK_SCRIPT; then
        echo "The file pointed to by HOOK_SCRIPT does not exist, check your container mounts.";
        exit 1;
    fi;

    if ! test -x $HOOK_SCRIPT; then
        echo "HOOK_SCRIPT is not an executable file (missing +x bit), check file permissions of the hook script."
        exit 1;
    fi;
fi;

ADDITIONAL_ARGS=$(if [[ -n "$WATCH_EVENTS" ]]; then echo "-e $WATCH_EVENTS"; else echo ""; fi)

while inotifywait $ADDITIONAL_ARGS -r /opt/monitor; do
    $HOOK_SCRIPT
done;
