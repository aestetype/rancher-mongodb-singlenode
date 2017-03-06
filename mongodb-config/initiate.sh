#!/bin/bash

if [ -n "$CATTLE_SCRIPT_DEBUG" ]; then
	set -x
fi

# Run cluster init script
/opt/rancher/bin/connect.sh &

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
