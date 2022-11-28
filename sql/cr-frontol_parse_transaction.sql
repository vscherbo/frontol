-- Function: frontol_parse_transaction()

-- DROP FUNCTION cash.frontol_parse_transaction();

CREATE OR REPLACE FUNCTION cash.frontol_parse_transaction(arg_ft_doc_num integer)
  RETURNS void AS
$BODY$
DECLARE
loc_bill_no integer;
loc_firm varchar;
BEGIN

WITH rcpt AS (SELECT ft_doc_num, SUM(ft_sum)AS ft_sum, payment_type
    FROM cash.vw_ft_fisc_payment_f6 
    WHERE ft_type IN (40,41) --  без 43!
    AND ft_doc_num = arg_ft_doc_num
    GROUP BY ft_doc_num, payment_type)
INSERT INTO "ОплатыНТУ"("Счет", "ДатаПоступления", "Сумма", ps_id2, "Примечание")
SELECT 
    -- order_id::integer
    COALESCE (order_id::integer, cash.origin_order_id(arg_ft_doc_num))
    , ft_date -- f36::date
    , p.ft_sum
    , CASE WHEN '1' = p.payment_type THEN 4 WHEN '2' = p.payment_type THEN 5 ELSE -1 END AS ps_id2
    -- '1' и '2' - кодировка видов оплат из БД кассы
    -- , 'Кассовый чек ' || c.ft_doc_num AS "Примечание"
    , cash.doc_title(c.ft_doc_num) AS "Примечание"
FROM cash.vw_ft_close_doc_f6 c
    CROSS JOIN rcpt p -- ON p.ft_doc_num = arg_ft_doc_num
    WHERE c.ft_doc_num = arg_ft_doc_num ;

SELECT order_id::integer INTO loc_bill_no FROM cash.vw_ft_close_doc_f6 c WHERE c.ft_doc_num = arg_ft_doc_num;
RAISE NOTICE 'loc_bill_no=%', loc_bill_no;
SELECT "фирма" into loc_firm FROM "Счета" WHERE "№ счета" = loc_bill_no;
RAISE NOTICE 'loc_firm=%', loc_firm;
UPDATE cash.receipt_queue SET status=1, dt_import=clock_timestamp() WHERE bill_no = loc_bill_no and cash_tag = loc_firm;
UPDATE "Счета" SET "Накладная" = now()::date::timestamp, "Статус" = 10, "Отгружен" = 't', "Оплачен" = 't', ps_id = 4 WHERE "№ счета" = loc_bill_no;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

