-- Function: fntr_parse_transaction()

-- DROP FUNCTION cash.fntr_parse_transaction();

CREATE OR REPLACE FUNCTION cash.fntr_parse_transaction()
  RETURNS trigger AS
$BODY$BEGIN

WITH rcpt AS (SELECT ft_doc_num, SUM(ft_sum)AS ft_sum, payment_type
    FROM cash.vw_ft_fisc_payment 
    WHERE ft_type IN (40,41) --  без 43!
    AND ft_doc_num = NEW.ft_doc_num
    GROUP BY ft_doc_num, payment_type)
INSERT INTO "ОплатыНТУ"("Счет", "ДатаПоступления", "Сумма", ps_id2, "Примечание")
SELECT 
    order_id::integer
    ,  f36::date
    , p.ft_sum
    , CASE WHEN '1' = p.payment_type THEN 4 WHEN '2' = p.payment_type THEN 5 ELSE -1 END AS ps_id2
    , 'Кассовый чек ' || c.ft_doc_num AS "Примечание"
FROM cash.vw_ft_close_doc c
    CROSS JOIN rcpt p -- ON p.ft_doc_num = NEW.ft_doc_num
    WHERE c.ft_doc_num = NEW.ft_doc_num ;

UPDATE cash.receipt_queue SET status=1 WHERE bill_no = (SELECT order_id::integer FROM cash.vw_ft_close_doc c WHERE c.ft_doc_num = NEW.ft_doc_num );

RETURN NEW;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

