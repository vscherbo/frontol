-- DROP FUNCTION cash.doc_title(integer);

CREATE OR REPLACE FUNCTION cash.doc_title(arg_doc_num integer)
  RETURNS text AS
$BODY$
SELECT format('Чек %s №%s',
(SELECT    
CASE 
    WHEN '1' = f23 THEN 'Продажа' 
    WHEN '2' = f23 THEN 'Возврат' 
    WHEN '3' = f23 THEN 'Аннулирование' 
    WHEN '4' = f23 THEN 'Обмен' 
    WHEN '5' = f23 THEN 'Внесение' 
    WHEN '6' = f23 THEN 'Выплата' 
    ELSE 'Иное'
END
FROM cash.vw_ft_close_doc WHERE ft_doc_num = arg_doc_num), arg_doc_num) AS RESULT;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;

