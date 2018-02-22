#!/bin/sh
basedir=/home/oracle/scripts/odo
entityname=$(hostname -s)_asap
engine_name=$(hostname -s)_engine
output=$basedir/odoengineasap.json
source $basedir/odomeIds

checkentity="python entity_check.py $entityname usr_odo_engine_asap"
result=$(eval $checkentity)

if [ $result != "0" ]; then
        meId=$result
        meName=$entityname
else
        echo "{"                                                                                > $output
        echo "    \"entityType\": \"usr_odo_engine_asap\","  >> $output
        echo "    \"entityName\": \"$entityname\","     >> $output
        echo "    \"displayName\": \"ASAP\","     >> $output
        echo "    \"properties\": {"                                    >> $output
        echo "    \"capability\": {"                                    >> $output
        echo "    \"displayName\": \"Capability\","     >> $output
        echo "    \"value\": \"monitoring\""                    >> $output
        echo "    },"                                                                   >> $output
        echo "    \"orcl_usr_gtp1\": {" >> $output
        echo "    \"displayName\" : \"Campaign\"," >> $output
        echo "    \"value\": \"$odocampaign_name\"" >> $output
        echo "    }" >> $output
        echo "    },"                                                                   >> $output
        echo "    \"tags\":{" >> $output
        echo "    \"campaign\" : \"$odocampaign_name\"," >> $output
        echo "    \"engine\" : \"$engine_name\"" >> $output
        echo "    },"                                                                   >> $output
        echo "    \"availabilityStatus\": \"UP\","              >> $output
        echo "    \"meClass\": \"TARGET\","                     >> $output
        echo "    \"agentBasedAvailability\": \"UP\""   >> $output
        echo "}"                                                                                >> $output

        meId=$(curl -X POST \
                        https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/tm-data/mes \
                        -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
                        -H 'cache-control: no-cache' \
                        -H 'content-type: application/json' \
                        -d '@/home/oracle/scripts/odo/odoengineasap.json' \
                        | grep -o -P '(?<=\"meId\":\").*(?=\")')

        meName=$(curl -X GET \
                        https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/$meId \
                        -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
                        -H 'cache-control: no-cache' \
                        -H 'content-type: application/json' \
                        |  grep -o -P '(?<=\"entityName\":\").*(?=\",\"properties)')
fi

# Write variable to file - to be used later
odomeIds=$basedir/odomeIds
if [ -e "$odomeIds" ]; then
        echo "odoengineasap_meId"=$meId >> $odomeIds
        echo "odoengineasap_name"=$meName >> $odomeIds
else
        echo "#!/bin/bash" > $odomeIds
        echo "odoengineasap_meId"=$meId >> $odomeIds
        echo "odoengineasap_name"=$meName >> $odomeIds
fi

