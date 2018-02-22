spool on;
set heading off;
set feedback off;
set verify off;
spool /home/oracle/scripts/odo/odoengine_metric_ordersummary.values;
SELECT
'total_orders=' || (select count(1) as total_orders from ordermgmt.om_order_header) || '
open_orders=' || (select count(1) as open_orders from ordermgmt.om_order_header where ord_state_id in (1,2,4,5,6,8)) || '
successful_orders=' || (select count(1) as successful_orders from ordermgmt.om_order_header where ord_state_id in (3,7,9)) || '
failed_orders=' || (select count(1) as failed_orders from ordermgmt.om_order_header where ord_state_id in (10))
FROM
    dual;
spool off;
exit;

