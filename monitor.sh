#!/usr/bin/env sh

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
fi

while inotifywait -r /opt/monitor; do
    $HOOK_SCRIPT
done;