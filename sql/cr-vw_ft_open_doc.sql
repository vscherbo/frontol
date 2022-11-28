CREATE VIEW cash.vw_ft_open_doc_f6 AS 
SELECT ft_id,ft_date, ft_time, ft_type, ft_wrkplace, ft_doc_num, ft_cashier_id
, (format('(%s)',ft_tail)::cash.t_ft42_f6).*  FROM cash.frontol_trans_f6 WHERE ft_type = 42;
