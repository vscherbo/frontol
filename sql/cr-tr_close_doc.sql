-- Trigger: tr_close_doc on frontol_trans

-- DROP TRIGGER tr_close_doc ON cash.frontol_trans;

CREATE TRIGGER tr_close_doc
  AFTER INSERT
  ON cash.frontol_trans
  FOR EACH ROW
  WHEN (new.ft_type = 55)
  EXECUTE PROCEDURE cash.fntr_parse_transaction();
