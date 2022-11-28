CREATE OR REPLACE VIEW cash.vw_ft_close_doc AS 
SELECT ft_id,ft_date, ft_time, ft_type, ft_wrkplace, ft_doc_num, ft_cashier_id
, (format('(%s)',ft_tail)::cash.t_ft55).*  FROM cash.frontol_trans WHERE ft_type = 55;
