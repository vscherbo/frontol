-- Drop table

-- DROP TABLE cash.receipt_queue

CREATE TABLE cash.receipt_queue (
	id serial NOT NULL,
	bill_no int4 NULL,
	dt_insert timestamp NOT NULL DEFAULT clock_timestamp(),
	status int4 NOT NULL DEFAULT 0,
	import_result varchar NULL,
	dt_import timestamp NULL,
	attempt_cnt int4 NOT NULL DEFAULT 0,
	CONSTRAINT receipt_queue_счета_fk FOREIGN KEY (bill_no) REFERENCES "Счета"("№ счета")
)
WITH (
	OIDS=FALSE
) ;

-- Permissions

ALTER TABLE cash.receipt_queue OWNER TO arc_energo;
