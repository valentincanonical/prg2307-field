#!/bin/bash -ex

trap '/bin/systemctl exit $?' ERR

CMD="rockcraft"
args="REPLACEME"

echo "INFO: Setting up the environment for Rockcraft..."

LXD_CHANNEL="latest/stable"

# Get pass the AppArmor "aa_is_enabled()" validation
mount -o rw,nosuid,nodev,noexec,relatime securityfs -t securityfs /sys/kernel/security

echo "INFO: Installing the LXD snap from $LXD_CHANNEL"
snap install lxd --channel $LXD_CHANNEL

echo "INFO: Installing Rockcraft from the 'edge' channel"

snap install rockcraft --edge --classic

echo "INFO: Initializing LXD..."

lxd init --auto

if [[ "$args" == "REPLACEME" ]]
then
    run_cmd="$CMD"
else
    run_cmd="${CMD} ${args}"
fi

echo "INFO: Executing: '$run_cmd' (LOOP 3s)"
while true; do sleep 3; $run_cmd; done;

cp /root/.local/state/rockcraft/log/rockcraft*log . || true

/bin/systemctl exit 0
