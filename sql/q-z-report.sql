SELECT ft_date as "Дата", ft_time "Время", shift "Номер смены", ft_doc_num "Номер документа", shift_takings "Выручка за смену" --, rcpt_doc_shift 
FROM cash.vw_ft_report
WHERE ft_type = 63