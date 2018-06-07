CREATE OR REPLACE FUNCTION cash.frontol_order_header(arg_bill_no integer)
 RETURNS text
 LANGUAGE sql
AS $function$
SELECT concat_ws(';', 
"№ счета", 1, to_char("Дата счета", 'DD.MM.YYYY'), --::date, 
concat_ws(':', extract('hour' FROM dt_create), extract('minute' FROM dt_create))
, "Сумма", '', "№ счета", '', '', '') || E'\r\n'
FROM "Счета"
WHERE "№ счета" = arg_bill_no;
$function$
