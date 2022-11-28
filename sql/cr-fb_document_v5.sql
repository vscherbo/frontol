-- Drop table

-- DROP TABLE cash.fb_document

CREATE TABLE cash.fb_document (
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
	CONSTRAINT fb_document_pk PRIMARY KEY (id)
)
WITH (
	OIDS=FALSE
);

-- Permissions

ALTER TABLE cash.fb_document OWNER TO arc_energo;
GRANT ALL ON TABLE cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(tableoid) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(cmax) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(xmax) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(cmin) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(xmin) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(ctid) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(id) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(dockindid) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(chequenumber) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(opendate) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(opentime) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(closedate) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(closetime) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(state) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(summ) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(summwd) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(ecrsession) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(chequetype) ON cash.fb_document TO arc_energo;
GRANT ALL, SELECT, INSERT, UPDATE, DELETE, REFERENCES(orderidentif) ON cash.fb_document TO arc_energo;
