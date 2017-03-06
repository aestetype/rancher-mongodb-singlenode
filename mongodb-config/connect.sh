#!/bin/bash

if [ -n "$CATTLE_SCRIPT_DEBUG" ]; then
	set -x
fi

GIDDYUP=/opt/rancher/bin/giddyup

function cluster_init {
	sleep 10
	# MYIP=$($GIDDYUP ip myip)
  # Using hostname instead of ips to solve this: https://jira.mongodb.org/browse/NODE-746
  MYHOSTNAME=$($GIDDYUP ip myname)
	mongo --eval "printjson(rs.initiate({_id :'rs0', members:[{_id:0, host:'$MYHOSTNAME.rancher.internal:27017'}]}))"
	for member in $($GIDDYUP ip stringify --use-container-names --delimiter " "); do
		if [ "$member" != "$MYHOSTNAME" ]; then
			mongo --eval "printjson(rs.add('$member.rancher.internal:27017'))"
			sleep 5
		fi
	done
}

sleep 10
cluster_init
