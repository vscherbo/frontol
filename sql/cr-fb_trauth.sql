-- Drop table

-- DROP TABLE cash.fb_trauth_f6

CREATE TABLE cash.fb_trauth_f6 (
	id int4 NOT NULL,
	documentid int4 NOT NULL,
	rmkoperationtype int4 NOT NULL,
	tranztype int4 NOT NULL,
	operationtype int4 NOT NULL,
	slipnumber int4 NOT NULL,
	referencenumber text NULL,
	canceled int4 NULL,
	resultcode int4 NULL,
	responsecode int4 NULL,
	protocol int4 NULL,
    cashsum numeric,
    printformid integer,
	CONSTRAINT fb_trauth_f6_pk PRIMARY KEY (id)
)
WITH (
	OIDS=FALSE
);
