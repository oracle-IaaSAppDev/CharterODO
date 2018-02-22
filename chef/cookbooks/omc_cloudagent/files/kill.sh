#!/bin/bash
getArray() {
    array=() # Create array
    while IFS= read -r line # Read a line
    do
        array+=("$line") # Append line to the array
    done < "$1"
}

getArray "/home/oracle/scripts/odo/odomeIds"
declare -A ary
for line in "${array[@]}"
do
     key=${line%%=*}
     value=${line#*=}
     ary[$key]=$value
done
mydate=$(date --utc +%FT%TZ)
# stop cronjob to prevent race condition on status
rm -rf /var/spool/cron/oracle
# curl command to mark DB down
#
curl -X PUT \
 https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "collectionTs" : "'"$mydate"'",
    "entityId": "'"${ary[odoenginedbinstance_meId]}"'",
    "entityName" : "'"${ary[odoenginedbinstance_name]}"'",
    "entityType" : "omc_oracle_db_instance",
    "entityDisplayName" : "'"${ary[odoenginedbinstance_name]}"'_decom",
    "namespace" : "EMAAS",
    "availabilityStatus": "DOWN"
}'

#
# Curl Command to mark OSM down

curl -X PUT \
 https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "collectionTs" : "'"$mydate"'",
    "entityId": "'"${ary[odoengineosm_meId]}"'",
    "entityName" : "'"${ary[odoengineosm_name]}"'",
    "entityType" : "usr_odo_engine_osm",
    "entityDisplayName" : "'"${ary[odoengineosm_name]}"'_decom",
    "namespace" : "EMAAS",
    "availabilityStatus": "DOWN"
}'


#
# Curl for ASAP

curl -X PUT \
 https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "collectionTs" : "'"$mydate"'",
    "entityId": "'"${ary[odoengineasap_meId]}"'",
    "entityName" : "'"${ary[odoengineasap_name]}"'",
    "entityType" : "usr_odo_engine_asap",
    "entityDisplayName" : "'"${ary[odoengineasap_name]}"'_decom",
    "namespace" : "EMAAS",
    "availabilityStatus": "DOWN"
}'

#
# Curl for Engine
curl -X PUT \
 https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "collectionTs" : "'"$mydate"'",
    "entityId": "'"${ary[odoengine_meId]}"'",
    "entityName" : "'"${ary[odoengine_name]}"'",
    "entityType" : "usr_odo_engine",
    "entityDisplayName" : "'"${ary[odoengine_name]}"'_decom",
    "namespace" : "EMAAS",
    "availabilityStatus": "DOWN"
}'

#
# Deinstall Oracle Management Cloud Agent
su - oracle -c "/omc/cloud_agent/core/*/sysman/install/AgentInstall.sh -deinstall"
