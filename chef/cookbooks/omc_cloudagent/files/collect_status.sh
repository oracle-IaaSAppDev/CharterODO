#!/bin/sh
#export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
#export ORACLE_SID=DB11G
source /home/oracle/.bash_profile
mydate=$(date --utc +%FT%TZ)
basedir=/home/oracle/scripts/odo
source $basedir/odomeIds

# Check for the OSM URL
statusout=$(curl -u admin:Password123 -i -s http://$(hostname):8001/OrderManagement/wsapi | grep "HTTP/1.1 200 OK" | grep -o "OK")

if [ "$statusout" == "OK" ]
then
        osmupordown="UP"
      else
    osmupordown="DOWN"
fi

output=$basedir/status_osm.json

echo "{" > $output
echo "    \"collectionTs\" : \""$mydate"\"," >> $output
echo "    \"entityId\": \""$odoengineosm_meId"\"," >> $output
echo "    \"entityName\" : \""$odoengineosm_name"\"," >> $output
echo "    \"entityType\" : \"usr_odo_engine_osm\"," >> $output
echo "    \"namespace\" : \"EMAAS\"," >> $output
echo "    \"availabilityStatus\": \""$osmupordown"\"" >> $output
echo "}" >> $output

# Check for the "Database"
#statusout=$(lsnrctl status | grep DB11G | grep -o READY | head -n1)
statusout=$(lsnrctl status | grep DB11G | awk '/READY/ && inDB11GWORLD==1 { print "UP"; gotit=1; inDB11GWORLD=0 } /DB11G.WORLD/ { inDB11GWORLD=1 } END { if (gotit==0) print "DOWN" }')

lsnrctl status > out.now

echo "dbinstance status: " $statusout

if [[ "$statusout" == "UP" ]]
then
        dbupordown="UP"
      else
    dbupordown="DOWN"
fi

output=$basedir/status_dbinstance.json

echo "{" > $output
echo "    \"collectionTs\" : \""$mydate"\"," >> $output
echo "    \"entityId\": \""$odoenginedbinstance_meId"\"," >> $output
echo "    \"entityName\" : \""$odoenginedbinstance_name"\"," >> $output
echo "    \"entityType\" : \"omc_oracle_db_instance\"," >> $output
echo "    \"namespace\" : \"EMAAS\"," >> $output
echo "    \"availabilityStatus\": \""$dbupordown"\"" >> $output
echo "}" >> $output

# Check for the ASAP process
. /home/oracle/.bash_profile
. /home/oracle/.bashrc
asapcoreenv

statusout=$(status | grep LOCAL | wc -l)

if [[ "$statusout" == 8 ]]
then
        asapupordown="UP"
      else
    asapupordown="DOWN"
fi

output=$basedir/status_asap.json

echo "{" > $output
echo "    \"collectionTs\" : \""$mydate"\"," >> $output
echo "    \"entityId\": \""$odoengineasap_meId"\"," >> $output
echo "    \"entityName\" : \""$odoengineasap_name"\"," >> $output
echo "    \"entityType\" : \"usr_odo_engine_asap\"," >> $output
echo "    \"namespace\" : \"EMAAS\"," >> $output
echo "    \"availabilityStatus\": \""$asapupordown"\"" >> $output
echo "}" >> $output

# Now determine with the this engine is available or not

if [[ "$asapupordown" == "UP" ]] && [[ "$dbupordown" == "UP" ]] && [[ "$osmupordown" == "UP" ]]; then
        odoengineupordown="UP"
else
        odoengineupordown="DOWN"
fi

odoengine_dispname=$odoengine_name
engine_drain_flag="$basedir/ENGINE_IS_DRAINING"
engine_clear_flag="$basedir/ENGINE_IS_CLEAR"
if [[ -e $engine_drain_flag || -e $engine_clear_flag ]]; then
        odoengine_dispname="${odoengine_dispname}_drain"
fi

output=$basedir/status_odoengine.json

echo "{" > $output
echo "    \"collectionTs\" : \""$mydate"\"," >> $output
echo "    \"entityId\": \""$odoengine_meId"\"," >> $output
echo "    \"entityName\" : \""$odoengine_name"\"," >> $output
echo "    \"entityDisplayName\" : \""$odoengine_dispname"\"," >> $output
echo "    \"entityType\" : \"usr_odo_engine\"," >> $output
echo "    \"namespace\" : \"EMAAS\"," >> $output
echo "    \"availabilityStatus\": \""$odoengineupordown"\"" >> $output
echo "}" >> $output
