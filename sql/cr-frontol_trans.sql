-- Drop table

-- DROP TABLE cash.frontol_trans

CREATE TABLE cash.frontol_trans (
	ft_id int4 NOT NULL,
	ft_date date NOT NULL,
	ft_time time NOT NULL,
	ft_type int4 NOT NULL,
	ft_wrkplace int4 NOT NULL,
	ft_doc_num int4 NOT NULL,
	ft_cashier_id int4 NOT NULL,
	ft_tail varchar NULL,
	CONSTRAINT frontol_trans_pk PRIMARY KEY (ft_id)
)
WITH (
	OIDS=FALSE
) ;

-- Permissions

ALTER TABLE cash.frontol_trans OWNER TO arc_energo;
