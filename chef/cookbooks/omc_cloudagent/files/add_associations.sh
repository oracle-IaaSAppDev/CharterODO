#!/bin/sh
basedir=/home/oracle/scripts/odo
entityname=$(hostname -s |  awk -F- '{print $1}')
output=$basedir/odoengine.json
source $basedir/odomeIds

curlCommand="curl -X GET 'https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/?entityName="$entityname"&entityType=usr_odo_campaign' -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' -H 'cache-control: no-cache' -H 'content-type: application/json' -H 'postman-token: 14301df8-5a11-61a1-5aa1-370bc9adb018'"

odocampaign_meId=$(eval $curlCommand | grep -o -P '(?<=\"entityId\":\").*(?=\"\,\"entityType\")')

# Create Associations
#
# Campaign
#       |-> Engine 1
#               |-> OSM
#               |-> Database Instance
#               |-> ASAP
#       |-> Engine 2
#               |-> OSM
#               |-> Database Instance
#               |-> ASAP

# Associate Engine to the Campaign
output=$basedir/assoc_engine_campaign.json
echo "{" > $output
echo "\"namespaceId\": \"EMAAS\"," >> $output
echo "\"assocType\": \"omc_uses\"," >> $output
echo "\"sourceMeId\": \""$odoengine_meId"\"," >> $output
echo "\"sourceEntityType\": \"usr_odo_engine\"," >> $output
echo "\"destMeId\": \""$odocampaign_meId"\"," >> $output
echo "\"destEntityType\": \"usr_odo_campaign\"" >> $output
echo "}" >> $output

curl -X POST \
  https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/tm-data/associations \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/assoc_engine_campaign.json'

# Associate OSM to the Engine
output=$basedir/assoc_osm_engine.json
echo "{" > $output
echo "\"namespaceId\": \"EMAAS\"," >> $output
echo "\"assocType\": \"omc_uses\"," >> $output
echo "\"sourceMeId\": \""$odoengineosm_meId"\"," >> $output
echo "\"sourceEntityType\": \"usr_odo_engine_osm\"," >> $output
echo "\"destMeId\": \""$odoengine_meId"\"," >> $output
echo "\"destEntityType\": \"usr_odo_engine\"" >> $output
echo "}" >> $output

curl -X POST \
  https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/tm-data/associations \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/assoc_osm_engine.json'

# Associate ASAP to the Engine
output=$basedir/assoc_asap_engine.json
echo "{" > $output
echo "\"namespaceId\": \"EMAAS\"," >> $output
echo "\"assocType\": \"omc_uses\"," >> $output
echo "\"sourceMeId\": \""$odoengineasap_meId"\"," >> $output
echo "\"sourceEntityType\": \"usr_odo_engine_asap\"," >> $output
echo "\"destMeId\": \""$odoengine_meId"\"," >> $output
echo "\"destEntityType\": \"usr_odo_engine\"" >> $output
echo "}" >> $output

curl -X POST \
  https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/tm-data/associations \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/assoc_asap_engine.json'

# Associate DB Instance to the Engine
output=$basedir/assoc_dbinstance_engine.json
echo "{" > $output
echo "\"namespaceId\": \"EMAAS\"," >> $output
echo "\"assocType\": \"omc_uses\"," >> $output
echo "\"sourceMeId\": \""$odoenginedbinstance_meId"\"," >> $output
echo "\"sourceEntityType\": \"omc_oracle_db_instance\"," >> $output
echo "\"destMeId\": \""$odoengine_meId"\"," >> $output
echo "\"destEntityType\": \"usr_odo_engine\"" >> $output
echo "}" >> $output

curl -X POST \
  https://uscgbuodo3trial.analytics.management.us2.oraclecloud.com/serviceapi/tm-data/associations \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/assoc_dbinstance_engine.json'
