#!/bin/bash

export basedir=/home/oracle/scripts/odo
export engine_drain_flag="$basedir/ENGINE_IS_DRAINING"
export engine_clear_flag="$basedir/ENGINE_IS_CLEAR"
export ask_death_flag="/tmp/DirectTouch-askdeath"
export user_shutdown_flag="$basedir/USER_REQUESTED_SHUTDOWN"

source $basedir/odomeIds
mydate=$(date --utc +%FT%TZ)

# Engine Capacity threshold variable
threshold_value=80

function checkCapacity {
    alert_message=""

	# First check if we have been asked to shutdown
	if [ -e $ask_death_flag ]; then
		alert_message="User requested shutdown"
		touch $user_shutdown_flag
	else
		# Now check the actual metrics for over capacity
		# odoengine_capacity.values will give us the variables largeindexpctused, largedatapctused, orderidpctused, rfs_capcity
		cat $basedir/odoengine_capacity.values | awk "NF > 0 { print }" | while read line; do
			metric_name=`echo $line | cut -f1 -d=`
			metric_value=`echo $line | cut -f2 -d=`
			metric_exceeded=`echo "$metric_value >= $threshold_value" | bc -l`
			if [[ "$metric_exceeded" -eq 1 ]]; then
				case "$metric_name" in
					rfs_capcity) alert_source="Root File System utilization" ;;
					orderidpctused) alert_source="Order ID utilization" ;;
					largedatapctused) alert_source="DB Data utilization" ;;
					largeindexpctused) alert_source="DB Index utilization" ;;
					*) alert_source="Unknown component" ;;
				esac
				alert_message="$alert_source is over capacity"
				break
			fi
		done
	fi
	
	if [ ! -z "$alert_message" ]; then
		touch $engine_drain_flag

		# Script to disable port forwarding
		sudo iptables -D PREROUTING -t nat -i eth0 -p tcp --dport 8101 -j REDIRECT --to-port 8001

		# Mark engine metric group and/or properties to reflect new status with message
		# Property or metric is set to True for an email alert
		# Set alert flag for engine in OMC as metric
		# Set alert message - $alert_message - for engine in OMC as metric

		curl -X POST \
  			https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/metrics/ \
  			-H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
			-H 'cache-control: no-cache' \
			-H 'content-type: application/octet-stream' \
			-d '[{
				"entityName": "'"$odoengine_name"'",
				"entityId": "'"$odoengine_meId"'",
				"collectionTs": "'"$mydate"'",
				"entityType": "usr_odo_engine",
				"metricGroup" : "engine_status_metrics",
				"metricNames" : [
					"status_alert_flag",
					"status_alert_message"
				],
				"metricValues" : [
				[
					1,
					"'"$alert_message"'"
				]]}]'

		#
		# Set engine name to <engine_name>_drain
		curl -X PUT \
 			https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  			-H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
			-H 'cache-control: no-cache' \
			-H 'content-type: application/json' \
			-d '{
				"collectionTs" : "'"$mydate"'",
				"entityId": "'"$odoengine_meId"'",
				"entityName" : "'"$odoengine_name"'",
				"entityType" : "usr_odo_engine",
				"displayName" : "'"$odoengine_name"'_drain",
				"namespace" : "EMAAS",
				"availabilityStatus": "UP"
			}'
    fi
}

function checkDrained {
      inflight=`cat $basedir/odoengine_metric_ordersummary.values | grep open_orders | cut -f2 -d=`
      if [[ "$inflight" -eq 0 ]]; then
        echo "Engine is drained"
        rm $engine_drain_flag
        touch $engine_clear_flag
        $basedir/taint.sh
    fi
}

# main line
if [ -e $engine_clear_flag ]; then
    # Do nothing, we are waiting for engine death
    :
elif [ -e $engine_drain_flag ]; then
    # We are draining; see if in-flights go down to zero
    checkDrained
else
    checkCapacity
fi
