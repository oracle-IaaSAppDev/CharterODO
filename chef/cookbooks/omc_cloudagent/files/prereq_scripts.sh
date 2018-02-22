#!/bin/sh
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export ORACLE_SID=DB11G

# Add objeccts to the database
$ORACLE_HOME/bin/sqlplus sys/Password123 as sysdba @/home/oracle/scripts/odo/prereq_db_directory.sql

# Add a cron job
(crontab -l 2>/dev/null; echo "*/1 * * * * /home/oracle/scripts/odo/collect_metrics.sh >  /home/oracle/scripts/odo/collect_metrics.log 2>&1") | crontab -
