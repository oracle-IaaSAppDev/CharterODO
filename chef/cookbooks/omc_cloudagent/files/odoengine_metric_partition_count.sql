DECLARE
        file1 utl_file.file_type;
        nowsdate varchar2(50);
        v_sql varchar2(500);
        v_count integer;
        v_totalpartitions integer;
        v_loopcounter integer := 0;
        v_ending varchar2(1);
BEGIN
SELECT to_char(sysdate,'YYYY-MM-DD"T"HH24:MI:SS"Z"')
  INTO nowsdate
 FROM dual;

select count(1)
  into v_totalpartitions
  from all_tab_partitions
 where table_name = 'OM_ORDER_HEADER'
 order by partition_name;

file1:= utl_file.fopen('ODOENGINE','odoengine_metric_partition_count.json','w');
utl_file.put_line(file1,'[');
utl_file.put_line(file1,'{');
utl_file.put_line(file1,'"collectionTs" : "'||nowsdate||'",');
utl_file.put_line(file1,'"entityType" : "usr_odo_engine",');
utl_file.put_line(file1,'"metricGroup" : "partition_counts",');
utl_file.put_line(file1,'"metricNames" : [');
utl_file.put_line(file1,'"partition_name",');
utl_file.put_line(file1,'"partition_count"');
utl_file.put_line(file1,'],');
utl_file.put_line(file1,'"metricValues" : [');

for p in
(select partition_name
from all_tab_partitions
where table_name = 'OM_ORDER_HEADER'
order by partition_name
)
loop
v_loopcounter := v_loopcounter + 1;
v_sql := 'select count(*) from ordermgmt.om_order_header partition('||p.partition_name||')';
execute immediate v_sql into v_count;
if v_loopcounter = v_totalpartitions then
        v_ending := '';
else
        v_ending := ',';
end if;

utl_file.put_line(file1,'[');
utl_file.put_line(file1,'"'||p.partition_name||'",' ||v_count);
utl_file.put_line(file1,']'||v_ending);
end loop;
utl_file.put_line(file1,']');
utl_file.put_line(file1,'}');
utl_file.put_line(file1,']');
utl_file.fclose(file1);
END;
/
exit;
