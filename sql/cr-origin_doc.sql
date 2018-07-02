-- DROP FUNCTION cash.origin_doc(integer);

CREATE OR REPLACE FUNCTION cash.origin_doc(arg_doc_num integer)
  RETURNS integer AS
$BODY$
SELECT f25::integer AS RESULT 
FROM cash.vw_ft_close_doc 
WHERE arg_doc_num = ft_doc_num;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;

