-- drop function cash.frontol_export_bill(integer);

CREATE OR REPLACE FUNCTION cash.frontol_export_bill(arg_bill_no integer, OUT out_res boolean, OUT out_rc integer)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
declare
arg_order text[];
loc_order_path text;
BEGIN
out_res := 'f'; -- initial 
out_rc := 2; -- initial 
PERFORM 1 FROM cash.receipt_queue WHERE bill_no = arg_bill_no;
IF FOUND THEN
    out_rc := 1; -- уже экспортирован
ELSE
    SELECT array(SELECT txt FROM (
    SELECT 10 AS weight, cash.frontol_order_header(arg_bill_no) AS txt
    union
    SELECT 20 AS weight, cash.frontol_order_items(arg_bill_no) AS txt
    ORDER BY weight) AS f) INTO arg_order;
        -- RAISE NOTICE 'arg_order=%', arg_order;
        if pg_production() then
            loc_order_path := arc_const('frontol_path');
        else
            loc_order_path := 'devel_frontol_orders';
        end if;
        -- res := cash.sftp_text(arc_const('frontol_user'), arc_const('frontol_host'), 22, format('%s/order_%s.opn', arc_const('frontol_path'), arg_bill_no), arg_order);
        out_res := cash.sftp_text(arc_const('frontol_user'), arc_const('frontol_host'), 22, format('%s/order_%s.opn', loc_order_path, arg_bill_no), arg_order);
        if out_res then
            insert into cash.receipt_queue(bill_no) values(arg_bill_no);
            out_rc := 0;
        end if;

END IF;
RAISE NOTICE 'res=%, rc=%', out_res, out_rc;

--    RETURN out_res;
end;$function$
