-- Drop table

-- DROP TABLE cash.receipt_queue

CREATE TABLE cash.receipt_queue (
	id serial NOT NULL,
	bill_no int4 NOT NULL,
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

COMMENT ON COLUMN cash.receipt_queue.status IS '0 - отправлен на кассу, 1 - получен чек, 2 - отозван';

-- Permissions

ALTER TABLE cash.receipt_queue OWNER TO arc_energo;


-- несколько касс
ALTER TABLE cash.receipt_queue ADD cash_tag varchar NOT NULL DEFAULT 'ИПБ';
CREATE UNIQUE INDEX receipt_queue_bill_no_idx ON cash.receipt_queue USING btree (bill_no, cash_tag);
