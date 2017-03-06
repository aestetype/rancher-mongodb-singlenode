#!/bin/bash

if [ -n "$CATTLE_SCRIPT_DEBUG" ]; then
	set -x
fi

/opt/rancher/bin/initiate.sh $@
