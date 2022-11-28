-- cash.ucs_register definition

-- Drop table

-- DROP TABLE cash.ucs_register;

CREATE TABLE cash.ucs_register (
    term_id varchar NOT NULL,
    txn_type varchar NULL,
    txn_date date NULL,
    ct_id varchar NULL,
    acc_key varchar NULL,
    card_mask varchar NOT NULL,
    auth_code varchar NOT NULL,
    gross_amount numeric NULL,
    ind_data varchar NULL,
    slip_no varchar NOT NULL,
    pc_key varchar NULL,
    grp_date date NULL,
    exp_comm numeric NULL,
    CONSTRAINT ucs_register_pk PRIMARY KEY (term_id, auth_code, card_mask, slip_no)
);
