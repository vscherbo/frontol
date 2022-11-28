drop type cash.t_ft42;
create type cash.t_ft42 as (
cli_cards text, -- 08 Номера карт клиента через |
text01   text, -- 09 Коды значений разрезов через запятую
num01    numeric, -- 10 всегда 0
qnt      numeric, -- 11 Количество товара
ft_sum   numeric, -- 12 Итоговая сумма документа в базовой валюте
op       integer, -- 13 операция
shift    integer, -- 14 номер смены
cli_code numeric, -- 15
num02    numeric, -- 16 empty
prn_grp_code integer, -- 17
bonus    text, -- 18
order_id text, -- 19 № счёта
f20 text,
f21 text,
f22 text,
f23 text,
f24 text,
f25 text,
f26 text,
f27 text,
f28 text,
f29 text,
f30 text,
f31 text,
f32 text,
f33 text,
f34 text,
f35 text,
f36 text,
f37 text,
f38 text,
f39 text,
f40 text,
f41 text,
f42 text,
f43 text
);
