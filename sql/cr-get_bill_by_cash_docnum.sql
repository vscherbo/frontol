CREATE OR REPLACE FUNCTION arc_energo.get_bill_by_cash_docnum(arg_doc_num integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
-- Frontol5 select order_id::integer as result from cash.vw_ft_close_doc where ft_doc_num = $1;
select order_id::integer as result from cash.vw_ft_close_doc_f6 where ft_doc_num = $1;
$function$
