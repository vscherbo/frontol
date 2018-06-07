CREATE OR REPLACE FUNCTION cash.frontol_order_items(arg_bill_no integer)
 RETURNS setof text
 LANGUAGE plpgsql
AS $function$
BEGIN
RETURN QUERY SELECT concat_ws(';', '1', "КодСодержания", '', to_char("ЦенаНДС", 'FM99999999D99'), to_char("Кол-во", 'FM9999999D999')) || E'\r\n'
FROM "Содержание счета"  
WHERE "№ счета" = arg_bill_no
ORDER BY "ПозицияСчета"; 
RETURN;
END;
$function$
