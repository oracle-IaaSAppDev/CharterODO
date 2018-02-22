#!/bin/sh
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export ORACLE_SID=DB11G

basedir=/home/oracle/scripts/odo
source $basedir/odomeIds

$ORACLE_HOME/bin/sqlplus moncs/Password123 @/home/oracle/scripts/odo/odoengine_metric_ordersummary.sql
$ORACLE_HOME/bin/sqlplus moncs/Password123 @/home/oracle/scripts/odo/odoengine_metric_partition_count.sql

# Build order summary JSON file from the values file
source $basedir/odoengine_metric_ordersummary.values
output=$basedir/odoengine_metric_ordersummary.json
mydate=$(date --utc +%FT%TZ)
echo "[" > $output
echo "  {" >> $output
echo "    \"collectionTs\" : \""$mydate"\"," >> $output
echo "    \"entityType\" : \"usr_odo_engine\"," >> $output
echo "    \"metricGroup\" : \"engine_order_counts\"," >> $output
echo "    \"metricNames\" : [" >> $output
echo "          \"total_orders\"," >> $output
echo "          \"open_orders\"," >> $output
echo "          \"successful_orders\"," >> $output
echo "          \"failed_orders\"" >> $output
echo "    ]," >> $output
echo "    \"metricValues\" : [" >> $output
echo "      [" >> $output
echo "         "$total_orders"," >> $output
echo "         "$open_orders"," >> $output
echo "         "$successful_orders"," >> $output
echo "         "$failed_orders >> $output
echo "      ]" >> $output
echo "    ]" >> $output
echo "  }" >> $output
echo "]" >> $output

$basedir/odoengine_capacity.sh
$basedir/collect_status.sh

curl -X POST \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/metrics/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/octet-stream' \
  -d '@/home/oracle/scripts/odo/odoengine_metric_capacity.json'
curl -X POST \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/$odoengine_meId/metricGroups \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/odoengine_metric_ordersummary.json'
curl -X POST \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/$odoengine_meId/metricGroups \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/odoengine_metric_partition_count.json'

# Status Checks
curl -X PUT \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/status_asap.json'
curl -X PUT \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/status_dbinstance.json'
curl -X PUT \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/status_odoengine.json'
curl -X PUT \
  https://uscgbuodo3trial.itom.management.us2.oraclecloud.com/serviceapi/entityModel/data/entities/ \
  -H 'authorization: Basic dXNjZ2J1b2RvM3RyaWFsLm1hYXouYW5qdW1Ab3JhY2xlLmNvbTpUZXN0ITIzNA==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '@/home/oracle/scripts/odo/status_osm.json'

$basedir/monitor_engine.sh
