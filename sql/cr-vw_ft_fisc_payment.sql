CREATE OR REPLACE VIEW cash.vw_ft_fisc_payment_f6 AS 
SELECT ft_id,ft_date, ft_time, ft_type, ft_wrkplace, ft_doc_num, ft_cashier_id
, (format('(%s)',ft_tail)::cash.t_ft40).*  FROM cash.frontol_trans_f6 WHERE ft_type in (40, 41, 43)
and ft_doc_num not in (select ft_doc_num FROM frontol_trans_f6 WHERE frontol_trans_f6.ft_type = 56); -- исключаем отменённые
