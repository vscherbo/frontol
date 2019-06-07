CREATE OR REPLACE FUNCTION cash.frontol_revoke_order(arg_bill_no integer)
  RETURNS varchar
AS
$BODY$
DECLARE cmd character varying;
ret_str VARCHAR := '';
err_str VARCHAR := '';
wrk_dir text := '/var/lib/pgsql/frontol';
res_exec RECORD;
BEGIN                                                                            
    cmd := format('mv frontol_orders/order_%s.opn canceled_frontol_orders/', arg_bill_no);
    res_exec := public.exec_paramiko(arc_energo.arc_const('frontol_host'), 
                                     22,
                                     arc_energo.arc_const('frontol_user'),
                                     cmd);

    IF res_exec.err_str <> ''                                                    
    THEN                                                                         
       ret_str := format('ERROR: %s', res_exec.err_str);
    ELSE                                                                         
       ret_str := res_exec.out_str;
       UPDATE cash.receipt_queue SET status=2, dt_import=clock_timestamp() WHERE bill_no = arg_bill_no;
    END IF;                                                                      
    
    return ret_str;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
