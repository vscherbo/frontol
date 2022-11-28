-- cash.vw_ucs_payment source

CREATE OR REPLACE VIEW cash.vw_ucs_payment
AS SELECT r.gross_amount - r.exp_comm AS net_amount,
    "right"(t.cardnumber::text, 4) AS t_card,
    "right"(r.card_mask::text, 4) AS r_card,
    r.authcode AS r_authcode,
    t.authcode AS t_authcode,
    r.txn_date,
    r.grp_date,
    r.gross_amount,
    r.exp_comm,
    r.txn_type,
    t.documentid,
    t.referencenumber,
    t.rmkoperationtype,
    t.tranztype,
    t.operationtype,
    d.chequenumber,
    d.opendate,
    d.opentime,
    d.closetime,
    d.state,
    d.summ,
    d.orderidentif
   FROM fb_trauth_f6 t
     LEFT JOIN fb_document_f6 d ON t.documentid = d.id
     LEFT JOIN ucs_register r ON r.authcode::text = t.authcode::text AND "right"(t.cardnumber::text, 4) = "right"(r.card_mask::text, 4)
  WHERE t.authcode IS NOT NULL;

