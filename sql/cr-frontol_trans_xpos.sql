-- Drop table

-- DROP TABLE arc_energo.frontol_trans_xpos

CREATE TABLE frontol_trans_xpos (
    ft_id int4 NOT NULL,
    ft_date date NOT NULL,
    ft_time time NOT NULL,
    ft_type int4 NOT NULL,
    ft_wrkplace int4 NOT NULL,
    ft_doc_num int4 NOT NULL,
    ft_cashier_id int4 NOT NULL,
    ft_txt08 varchar NULL,
    ft_txt09 varchar NULL,
    ft_num10 numeric NULL,
    ft_num11 numeric NULL,
    ft_num12 numeric NULL,
    ft_int13 int4 NULL,
    ft_int14 int4 NULL,
    ft_num15 numeric NULL,
    ft_num16 numeric NULL,
    ft_txt17 varchar NULL,
    ft_txt18 varchar NULL,
    ft_int19 int4 NULL,
    ft_num20 numeric NULL,
    ft_int21 int4 NULL,
    ft_int22 int4 NULL,
    ft_txt23 varchar NULL,
    ft_int24 int4 NULL,
    ft_int25 int4 NULL,
    ft_txt26 varchar NULL,
    ft_int27 int4 NULL,
    ft_int28 int4 NULL,
    ft_int29 int4 NULL,
    ft_txt30 varchar NULL,
    ft_int31 int4 NULL,
    ft_int32 int4 NULL,
    ft_txt33 varchar NULL,
    ft_txt34 varchar NULL,
    CONSTRAINT frontol_trans_xpos_pk PRIMARY KEY (ft_id)
)
WITH (
    OIDS=FALSE
) ;
