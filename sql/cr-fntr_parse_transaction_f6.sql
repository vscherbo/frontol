-- Function: fntr_parse_transaction_f6()

-- DROP FUNCTION cash.fntr_parse_transaction_f6();

CREATE OR REPLACE FUNCTION cash.fntr_parse_transaction_f6()
  RETURNS trigger AS
$BODY$
DECLARE
loc_bill_no integer;
loc_firm varchar;
BEGIN

PERFORM cash.frontol_parse_transaction(NEW.ft_doc_num);
IF FOUND THEN
    RETURN NEW;
ELSE
    RETURN NULL;
END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

