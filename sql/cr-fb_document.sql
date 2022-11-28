-- Drop table

-- DROP TABLE cash.fb_document_f6

CREATE TABLE cash.fb_document_f6 (
	id int4 NOT NULL,
	dockindid int4 NOT NULL,
	chequenumber int4 NOT NULL,
	opendate date NOT NULL,
	opentime time NOT NULL,
	closedate date NOT NULL,
	closetime time NOT NULL,
	state int4 NOT NULL,
	summ numeric NOT NULL,
	summwd numeric NOT NULL,
	ecrsession int4 NOT NULL,
	chequetype int4 NOT NULL,
	orderidentif int4 NOT NULL,
	CONSTRAINT fb_document_f6_pk PRIMARY KEY (id)
)
WITH (
	OIDS=FALSE
);

