#!/bin/bash

if [ -n "$CATTLE_SCRIPT_DEBUG" ]; then
	set -x
fi

# Check for lowest ID
sleep 10
/opt/rancher/bin/giddyup leader check
if [ "$?" -eq "0" ]; then
    echo "This is the lowest numbered container.. Handling the initiation."
    /opt/rancher/bin/initiate.sh $@
else

# Start mongodb
if [ $? -ne 0 ]
then
echo "Error Occurred.."
fi

set -e

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi

if [ "$1" = 'mongod' ]; then
	chown -R mongodb /data/db

	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi

	exec gosu mongodb "$@"
fi
exec "$@"

fi
