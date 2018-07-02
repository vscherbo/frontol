-- DROP FUNCTION cash.origin_order_id(integer);

CREATE OR REPLACE FUNCTION cash.origin_order_id(arg_doc_num integer)
  RETURNS integer AS
$BODY$
SELECT order_id::integer AS RESULT
FROM cash.vw_ft_close_doc 
WHERE ft_doc_num = cash.origin_doc(arg_doc_num);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;

