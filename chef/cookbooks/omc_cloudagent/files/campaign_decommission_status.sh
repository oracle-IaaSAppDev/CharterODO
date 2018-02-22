#!/bin/sh

# This script expects a value to be passed, i.e. Campaign Name
mydate=$(date --utc +%FT%TZ)

curlCommand="curl -X GET 'https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/?entityName="$1"&entityType=usr_odo_campaign' -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' -H 'cache-control: no-cache' -H 'content-type: application/json' -H 'postman-token: 14301df8-5a11-61a1-5aa1-370bc9adb018'"

odocampaign_meId=$(eval $curlCommand | grep -o -P '(?<=\"entityId\":\").*(?=\"\,\"entityType\")')

#
# Change campaign status to decomissioned
#
curl -X PUT \
 https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "collectionTs" : "'"$mydate"'",
    "entityId": "'"$odocampaign_meId"'",
    "entityName" : "'"$1"'",
    "entityType" : "usr_odo_campaign",
    "entityDisplayName" : "'"$1"'_decom",
    "namespace" : "EMAAS",
    "availabilityStatus": "DOWN"
}'
