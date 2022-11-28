-- Drop table

-- DROP TABLE cash.frontol_trans_f6

CREATE TABLE cash.frontol_trans_f6 (
	ft_id int4 NOT NULL,
	ft_date date NOT NULL,
	ft_time time NOT NULL,
	ft_type int4 NOT NULL,
	ft_wrkplace int4 NOT NULL,
	ft_doc_num int4 NOT NULL,
	ft_cashier_id int4 NOT NULL,
	ft_tail varchar NULL,
	CONSTRAINT frontol_trans_f6_pk PRIMARY KEY (ft_id)
)
WITH (
	OIDS=FALSE
) ;

-- Permissions

ALTER TABLE cash.frontol_trans_f6 OWNER TO arc_energo;

create trigger tr_close_doc_f6 after insert on
cash.frontol_trans_f6 for each row
when ((new.ft_type = 55)) execute procedure fntr_parse_transaction_f6();

