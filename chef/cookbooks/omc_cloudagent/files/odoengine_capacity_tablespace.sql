spool on;
set heading off;
set feedback off;
set verify off;
spool /home/oracle/scripts/odo/odoengine_capacity.values;
SELECT
'largeindexpctused=' || (select ROUND(used_percent,2) as pct_used from dba_tablespace_usage_metrics where tablespace_name = 'LARGE_INDEX') || CHR(10) ||
'largedatapctused=' || (select ROUND(used_percent,2) as pct_used from dba_tablespace_usage_metrics where tablespace_name = 'LARGE_DATA')
FROM
    dual;
spool off;
exit;