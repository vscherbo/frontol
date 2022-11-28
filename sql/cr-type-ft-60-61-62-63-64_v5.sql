drop type cash.t_ft60;
create type cash.t_ft60 as (
f08 text,
f09 text,
shift_takings  numeric, -- 10 Выручка за смену 
cash_in_box    numeric, -- 11 Наличность в кассе
shift_result   numeric, -- 12 Сменный итог
f13      integer,
shift    integer, -- 14 номер смены
f15 numeric,
f16 numeric,
prn_grp_code integer, -- 17
f18 text,
f19 integer,
f20 numeric,
f21 integer,
f22 integer,
f23 integer,
f24 integer,
f25 int8,
rcpt_doc_shift text,
firm_id integer,
f28 integer,
f29 integer,
f30 text,
f31 integer,
f32 integer,
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
f43 text,
f44 text
);
