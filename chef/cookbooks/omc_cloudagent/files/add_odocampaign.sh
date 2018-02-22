#!/bin/sh
basedir=/home/oracle/scripts/odo
entityname=$(hostname -s |  awk -F- '{print $1}')
output=$basedir/odocampaign.json
mydate=$(date --utc +%FT%TZ)
enginenumber=$(hostname -s |  awk -F- '{print $2}')

if [ "$enginenumber" -lt "1" ]; then
        echo "{"                                                                                > $output
        echo "    \"entityType\": \"usr_odo_campaign\","  >> $output
        echo "    \"entityName\": \"$entityname\","     >> $output
        echo "    \"properties\": {"                                    >> $output
        echo "    \"capability\": {"                                    >> $output
        echo "    \"displayName\": \"Capability\","     >> $output
        echo "    \"value\": \"monitoring\""                    >> $output
        echo "    }"                                                                    >> $output
        echo "    ," >> $output
        echo "    \"orcl_usr_gtp1\": {" >> $output
        echo "    \"displayName\" : \"Campaign\"," >> $output
        echo "    \"value\": \"$entityname\"" >> $output
        echo "    }" >> $output
        echo "    },"                                                                   >> $output
        echo "    \"tags\":{" >> $output
        echo "    \"campaign\" : \"$entityname\"" >> $output
        echo "    }," >> $output
        echo "    \"availabilityStatus\": \"UP\","              >> $output
        echo "    \"meClass\": \"TARGET\","                     >> $output
        echo "    \"agentBasedAvailability\": \"UP\""   >> $output
        echo "}"                                                                                >> $output

        meId=$(curl -X POST \
          https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/tm-data/mes \
          -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
          -H 'cache-control: no-cache' \
          -H 'content-type: application/json' \
          -d '@/home/oracle/scripts/odo/odocampaign.json' \
                | grep -o -P '(?<=\"meId\":\").*(?=\")')

        meName=$(curl -X GET \
          https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/$meId \
          -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
          -H 'cache-control: no-cache' \
          -H 'content-type: application/json' \
                |  grep -o -P '(?<=\"entityName\":\").*(?=\",\"properties)')

	if [ -z "$meName" ]
	then
		meName=$entityname
	fi

	# This code will determine which incarnation to use for the engine name
	# <hostname -s>.<incarnation>_engine
	# for example; jarvis-0.0_engine
	pythoncommand="python get_engine_name.py"
	engineincarnation=$(eval $pythoncommand)

	output=$basedir/odocampaign_createdate.json

	if [[ $engineincarnation -eq 0 ]]; then
		echo "{ \"entityName\": \"$entityname\", " > $output
		echo "  \"entityId\": \"$meId\", " >> $output
		echo "  \"collectionTs\": \""$mydate"\", " >> $output
		echo "  \"entityType\": \"usr_odo_campaign\", " >> $output
		echo "  \"metricGroup\" : \"campaign_inception\", " >> $output
		echo "  \"metricNames\" : [ " >> $output
		echo "    \"create_date\" ], " >> $output
		echo "  \"metricValues\" : [[ " >> $output
		echo "    \"$(date)\"]]} " >> $output

		curl -X POST \
			https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/metrics/ \
			-H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
			-H 'cache-control: no-cache' \
			-H 'content-type: application/octet-stream' \
			-d '@/home/oracle/scripts/odo/odocampaign_createdate.json'	
	fi

        # Write variable to file - to be used later
        odomeIds=$basedir/odomeIds
        if [ -e "$odomeIds" ]; then
                echo "odocampaign_meId"=$meId >> $odomeIds
                echo "odocampaign_name"=$meName >> $odomeIds
        else
                echo "#!/bin/bash" > $odomeIds
                echo "odocampaign_meId"=$meId >> $odomeIds
                echo "odocampaign_name"=$meName >> $odomeIds
        fi
else
        odomeIds=$basedir/odomeIds
        if [ -e "$odomeIds" ]; then
                echo "odocampaign_meId"=$meId >> $odomeIds
                echo "odocampaign_name"=$entityname >> $odomeIds
        else
                echo "#!/bin/bash" > $odomeIds
                echo "odocampaign_meId"=$meId >> $odomeIds
                echo "odocampaign_name"=$entityname >> $odomeIds
        fi
fi
