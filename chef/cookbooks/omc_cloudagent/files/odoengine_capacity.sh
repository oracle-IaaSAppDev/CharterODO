#!/bin/sh
basedir=/home/oracle/scripts/odo
source $basedir/odomeIds
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export ORACLE_SID=DB11G

# This starts the spool file and collects first set of metrics for capacity
$ORACLE_HOME/bin/sqlplus sys/Password123 as sysdba @/home/oracle/scripts/odo/odoengine_capacity_tablespace.sql
$ORACLE_HOME/bin/sqlplus moncs/Password123 @/home/oracle/scripts/odo/odoengine_capacity_orderids.sql

basedir=/home/oracle/scripts/odo
source $basedir/odomeIds
source $basedir/odoengine_capacity.values
output=$basedir/odoengine_metric_capacity.json
mydate=$(date --utc +%FT%TZ)

rfs_capcity=$(df -h / | sed 1d | sed 's/%//' | awk '{print $5}')
echo "" >> $basedir/odoengine_capacity.values
echo "rfs_capcity=${rfs_capcity}" >> $basedir/odoengine_capacity.values

echo "[" > $output
echo "  {" >> $output
echo "    \"entityName\" : \""$odoengine_name"\"," >> $output
echo "    \"entityId\" : \""$odoengine_meId"\"," >> $output
echo "    \"collectionTs\" : \""$mydate"\"," >> $output
echo "    \"entityType\" : \"usr_odo_engine\"," >> $output
echo "    \"metricGroup\" : \"capacity_utilization\"," >> $output
echo "    \"metricNames\" : [" >> $output
echo "      \"large_index_pct_used\"," >> $output
echo "      \"large_data_pct_used\"," >> $output
echo "      \"root_filesystem_pct_used\"," >> $output
echo "      \"order_id_pct_used\"" >> $output
echo "    ]," >> $output
echo "    \"metricValues\" : [" >> $output
echo "      [" >> $output
echo "        "$largeindexpctused"," >> $output
echo "        "$largedatapctused"," >> $output
echo "        "$rfs_capcity"," >> $output
echo "        "$orderidpctused"" >> $output
echo "      ]" >> $output
echo "    ]" >> $output
echo "  }" >> $output
echo "]" >> $output

