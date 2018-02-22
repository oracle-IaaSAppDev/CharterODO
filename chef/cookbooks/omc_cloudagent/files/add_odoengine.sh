#!/bin/sh
basedir=/home/oracle/scripts/odo
entitydisplayname=$(hostname -s)_engine
output=$basedir/odoengine.json
source $basedir/odomeIds

# This code will determine which incarnation to use for the engine name
# <hostname -s>.<incarnation>_engine
# for example; jarvis-0.0_engine
pythoncommand="python get_engine_name.py"
engineincarnation=$(eval $pythoncommand)
entityname=$(hostname -s).$engineincarnation\_engine

echo "{"                                                                                > $output
echo "    \"entityType\": \"usr_odo_engine\","  >> $output
echo "    \"entityName\": \"$entityname\","     >> $output
echo "    \"displayName\": \"$entitydisplayname\","     >> $output
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
echo "    \"engine\" : \"$entitydisplayname\"" >> $output
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
  -d '@/home/oracle/scripts/odo/odoengine.json' \
        | grep -o -P '(?<=\"meId\":\").*(?=\")')

meName=$(curl -X GET \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/$meId \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
        |  grep -o -P '(?<=\"entityName\":\").*(?=\",\"properties)')

# Write variable to file - to be used later
odomeIds=$basedir/odomeIds
if [ -e "$odomeIds" ]; then
        echo "odoengine_meId"=$meId >> $odomeIds
        echo "odoengine_name"=$meName >> $odomeIds
else
        echo "#!/bin/bash" > $odomeIds
        echo "odoengine_meId"=$meId >> $odomeIds
        echo "odoengine_name"=$meName >> $odomeIds
fi
