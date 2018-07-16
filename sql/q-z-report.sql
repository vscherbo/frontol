SELECT r.ft_date as "Дата", r.ft_time "Время", r.shift "Номер смены"
, coalesce(rcpt_num, 0) "Количество чеков"
, coalesce(refund_num, 0) "Количество возвратов"
, r.shift_takings-r.shift_result "Возвраты за смену, руб."
, r.shift_takings "Выручка за смену, руб."
--, rcpt_doc_shift, r.ft_doc_num "Номер документа"
FROM cash.vw_ft_report r
left join (select c.ft_date, count(*) as rcpt_num from cash.vw_ft_close_doc c where c.ft_date = ft_date and c.op=0 group by ft_date) as sale on sale.ft_date= r.ft_date
left join (select c.ft_date, count(*) as refund_num from cash.vw_ft_close_doc c where c.ft_date = ft_date and c.op=1 group by ft_date) as refund on refund.ft_date= r.ft_date
WHERE r.ft_type = 63
and ft_date = now()::date;
--and r.ft_date = '2018-07-13';                                                                                                                                                     
