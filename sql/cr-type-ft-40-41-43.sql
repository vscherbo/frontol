drop type cash.t_ft40;
create type cash.t_ft40 as (
cli_cards text, -- 08 Номера карт клиента через |
payment_type   text, -- 09 Код вида оплаты
payment_op     numeric, -- 10 
ft_sum_curr   numeric, -- 11 
ft_sum        numeric, -- 12 Итоговая сумма документа в базовой валюте
op       integer, -- 13 операция
shift    integer, -- 14 номер смены
act_code integer, -- 15 Код акции
event_code   integer, -- 16 empty
prn_grp_code integer, -- 17
text18    text, -- 18 empty
currency_code integer, -- 19 Код валюты
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
f37 text
);
