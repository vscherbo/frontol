-- drop function cash.frontol_export_bill(integer);

CREATE OR REPLACE FUNCTION cash.frontol_export_bill(arg_bill_no integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
declare
arg_order text[];
res BOOLEAN;
BEGIN
SELECT array(SELECT txt FROM (
SELECT 10 AS weight, cash.frontol_order_header(arg_bill_no) AS txt
union
SELECT 20 AS weight, cash.frontol_order_items(arg_bill_no) AS txt
ORDER BY weight) AS f) INTO arg_order;
   -- RAISE NOTICE 'arg_order=%', arg_order;
   res := cash.sftp_text(arc_const('frontol_user'), arc_const('frontol_host'), 22, format('%s/order_%s.opn', arc_const('frontol_path'), arg_bill_no), arg_order);

   RAISE NOTICE 'res=%', res;
   RETURN res;
end;$function$
