#!/bin/sh
basedir=/home/oracle/scripts/odo

$basedir/add_odocampaign.sh
$basedir/add_odoengine.sh
$basedir/add_odoengineasap.sh
$basedir/add_odoenginedbinstance.sh
$basedir/add_odoengineosm.sh
$basedir/add_associations.sh


# Create ODO Engine's Group
source $basedir/odomeIds
engine_name=$(hostname -s)_engine

curl -X POST \
 https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/tm-data/groups/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
        "groupName": "'"$engine_name"'",
        "groupDisplayName": "'"$engine_name"'",
        "groupType": "Dynamic",
        "tagBasedCriteria" : { "key":"engine","value":"'"$engine_name"'" },
                "tags" : {
                        "campaign" : "'"$odocampaign_name"'"
        }
}'

#touch success script for chef
touch $basedir/success
