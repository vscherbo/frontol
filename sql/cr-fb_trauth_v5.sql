-- Drop table

-- DROP TABLE cash.fb_trauth

CREATE TABLE cash.fb_trauth (
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
	CONSTRAINT fb_trauth_pk PRIMARY KEY (id)
)
WITH (
	OIDS=FALSE
);

-- Permissions

ALTER TABLE cash.fb_trauth OWNER TO arc_energo;
GRANT ALL ON TABLE cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(tableoid) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(cmax) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(xmax) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(cmin) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(xmin) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(ctid) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(id) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(documentid) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(rmkoperationtype) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(tranztype) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(operationtype) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(slipnumber) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(referencenumber) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(canceled) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(resultcode) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(responsecode) ON cash.fb_trauth TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(protocol) ON cash.fb_trauth TO arc_energo;
