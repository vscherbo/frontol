-- Drop table

-- DROP TABLE cash.frontol_catalog

CREATE TABLE cash.frontol_catalog (
	ft_code varchar(10) NOT NULL,
	ft_barcode varchar NULL,
	ft_name varchar(128) NULL,
	ft_print_name varchar(128) NULL,
	ft_price numeric(2) NULL DEFAULT 0.00,
	ft_quantity numeric(4) NULL DEFAULT 0.00,
	ft_filler07 varchar NULL DEFAULT 0,
	ft_flags varchar NULL DEFAULT 0,
	ft_min_price numeric(2) NULL DEFAULT 0.00,
	ft_filler10 varchar NULL DEFAULT 0,
	ft_scheme_code varchar(12) NULL DEFAULT ''::character varying,
	ft_variant int4 NULL DEFAULT 0,
	ft_item_type int4 NULL DEFAULT 0, -- Признак предмета расчета:0 – не используется;1 – товар, кроме подакцизного;2 – подакцизный товар;3 – работа;4 – услуга;5 – товар, состоящий из нескольких признаков;6 – иной товар;7 – аванс, предоплата
	ft_barcode_coeff numeric NULL DEFAULT 1.0,
	ft_filler15 varchar NULL DEFAULT 0,
	ft_parent_group_code varchar(10) NULL,
	ft_group_sign int4 NULL DEFAULT 1,
	ft_payment_type int4 NULL DEFAULT 0,
	ft_filler19 varchar NULL,
	ft_series varchar(100) NULL,
	ft_certificate varchar(100) NULL,
	ft_filler22 varchar NULL,
	ft_tax_group_code int4 NULL, -- Код налоговой группы
	ft_filler24 varchar NULL,
	CONSTRAINT frontol_catalog_pk PRIMARY KEY (ft_code)
)
WITH (
	OIDS=FALSE
) ;

-- Column comments

COMMENT ON COLUMN cash.frontol_catalog.ft_item_type IS 'Признак предмета расчета:
0 – не используется;
1 – товар, кроме подак-
цизного;
2 – подакцизный товар;
3 – работа;
4 – услуга;
5 – товар, состоящий из
нескольких признаков;
6 – иной товар;
7 – аванс, предоплата' ;
COMMENT ON COLUMN cash.frontol_catalog.ft_tax_group_code IS 'Код налоговой группы' ;

-- Permissions

ALTER TABLE cash.frontol_catalog OWNER TO arc_energo;
GRANT ALL ON TABLE cash.frontol_catalog TO arc_energo;
