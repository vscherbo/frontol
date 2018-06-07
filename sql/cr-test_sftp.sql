CREATE OR REPLACE FUNCTION arc_energo.test_sftp()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
arg_order text[];
res BOOLEAN;
arg_bill_no integer = 12221064;
BEGIN
	SELECT array(SELECT txt FROM (
SELECT 10 AS weight, frontol_order_header(arg_bill_no) AS txt
union
SELECT 20 AS weight, frontol_order_items(arg_bill_no) AS txt
ORDER BY weight) AS f) INTO arg_order;
    -- RAISE NOTICE 'loc_int=%, loc_text=%', loc_int, loc_text;
    RAISE NOTICE 'arg_order=%', arg_order;
   -- res := sftp_text('uploader'::text, 'kipspb-fl.arc.world'::text, 22, format('/home/uploader/ext_order_%s.txt', arg_bill_no), arg_order);
   res := sftp_text('frontol'::text, 'cifs-frontol.arc.world'::text, 22, format('/mnt/r10/frontol/frontol_orders/order_%s.opn', arg_bill_no), arg_order);
   RAISE NOTICE 'res=%', res;
end;$function$
