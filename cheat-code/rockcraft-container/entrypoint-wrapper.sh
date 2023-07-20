#!/bin/bash -eux

args="$@"

sed -i "0,/REPLACEME/ s/REPLACEME/${args}/" /usr/local/bin/entrypoint.sh

exec /lib/systemd/systemd --system --system-unit entrypoint.service --show-status=true
