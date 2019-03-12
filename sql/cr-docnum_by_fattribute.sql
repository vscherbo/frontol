CREATE OR REPLACE FUNCTION cash.docnum_by_fattribute(arg_fattrtibute text, OUT out_ft_docnum integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
SELECT ft_doc_num as RESULT 
FROM cash.frontol_trans 
WHERE ft_type = 45
and (format('(%s)',ft_tail)::cash.t_ft55).f25 = arg_fattrtibute;
$function$;
