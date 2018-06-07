WITH rcpt AS (
SELECT ft_doc_num, SUM(ft_sum)AS ft_sum, payment_type
FROM cash.vw_ft_fisc_payment
WHERE
ft_type IN (40,41) -- ?
GROUP BY ft_doc_num, payment_type)
INSERT INTO "ОплатыНТУ"("Счет", "ДатаПоступления", "Сумма", ps_id2, "Примечание")
SELECT order_id::integer
,  c.f36::date
, p.ft_sum, 
CASE WHEN '1' = p.payment_type THEN 4 WHEN '2' = p.payment_type THEN 5 ELSE -1 END AS ps_id2 
, 'Кассовый чек ' || c.ft_doc_num AS "Примечание"
-- , p.*
FROM cash.vw_ft_close_doc c
JOIN rcpt p ON p.ft_doc_num = c.ft_doc_num
-- WHERE order_id NOT IN (SELECT Счет::text FROM ОплатыНТУ WHERE ps_id2 IN (4,5))
-- ORDER BY c.ft_doc_num

