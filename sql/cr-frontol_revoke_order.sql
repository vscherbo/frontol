drop function cash.frontol_revoke_order(integer, varchar);

CREATE OR REPLACE FUNCTION cash.frontol_revoke_order(arg_bill_no integer, arg_cash_tag varchar DEFAULT 'ИПБ')
  RETURNS varchar
AS
$BODY$
DECLARE cmd character varying;
ret_str VARCHAR := '';
err_str VARCHAR := '';
res_exec RECORD;
loc_order_path text;
loc_canceled_path text;
loc_const_path text;
loc_const_host text;
loc_dev_prefix text;
BEGIN                                                                            
    -- PERFORM 1 FROM cash.receipt_queue WHERE bill_no = arg_bill_no and status = 0;

    RAISE NOTICE 'arg_bill_no=%, arg_cash_tag=%', arg_bill_no, arg_cash_tag;
    if arg_cash_tag = 'ИПБ' then
        loc_const_path = 'frontol_path';
        loc_const_host = 'frontol_host';
    else
        loc_const_path = 'frontol_path_' || arg_cash_tag;
        loc_const_host = 'frontol_host_' || arg_cash_tag;
    end if;

    loc_order_path := arc_const(loc_const_path);                             
    if pg_production() then                                                  
        -- loc_order_path := arc_const('frontol_path');                      
    else                                                                     
        loc_order_path := replace(loc_order_path, '/frontol_orders', '/DEV/frontol_orders');
    end if;                                                                  
    loc_canceled_path := replace(loc_order_path,  'frontol_orders', 'canceled_frontol_orders');
    RAISE NOTICE 'loc_order_path=%, loc_canceled_path=%', loc_order_path, loc_canceled_path;

    if pg_production() then
        loc_dev_prefix := '';
    else
        loc_dev_prefix := 'DEV/';
    end if;

    -- cmd := format('mv %s/order_%s.opn canceled_frontol_orders/', loc_order_path, arg_bill_no);
    -- cmd := format('mv %sfrontol_orders/order_%s.opn %scanceled_frontol_orders/', loc_dev_prefix, arg_bill_no, loc_dev_prefix);
    cmd := format('mv %s/order_%s.opn %s/', loc_order_path, arg_bill_no, loc_canceled_path);

    res_exec := public.exec_paramiko(arc_energo.arc_const(loc_const_host), 
                                     22,
                                     arc_energo.arc_const('frontol_user'),
                                     cmd);

    IF res_exec.err_str <> ''                                                    
    THEN                                                                         
       ret_str := format('ERROR: %s', res_exec.err_str);
    ELSE                                                                         
       ret_str := res_exec.out_str;
       UPDATE cash.receipt_queue SET status=2, dt_import=clock_timestamp()
       WHERE bill_no = arg_bill_no 
             AND cash_tag = arg_cash_tag;
    END IF;                                                                      
    
    return ret_str;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
