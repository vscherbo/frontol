drop function cash.frontol_export_bill(integer, varchar);

CREATE OR REPLACE FUNCTION cash.frontol_export_bill(arg_bill_no integer, arg_cash_tag varchar DEFAULT 'ИПБ', OUT out_res boolean, OUT out_rc integer, OUT out_text text)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
declare
arg_order text[];
loc_order_path text;
loc_const_path text;
loc_const_host text;
str_canceled text := E'\r\nОперация отменена!';
/* out_rc
Успешно (Information): 64
Exclamation:  48
Critical: 16
*/
BEGIN
out_res := 'f'; -- initial
out_rc := 16; -- initial. Critical
out_text := E'ВНИМАНИЕ!\r\nОтправка на кассу не прошла, повторите операцию и/или обратитесь в отдел ИТ';
-- status 0 - отправлен на кассу => ЗАПРЕТ повторного экспорта
-- status 1 - получен чек => ЗАПРЕТ повторного экспорта
PERFORM 1 FROM cash.receipt_queue WHERE bill_no = arg_bill_no and status in (0,1);
IF FOUND THEN
    out_rc := 48; -- уже экспортирован, Excalmation
    out_text := E'Этот счет уже был отправлен на кассу!' || str_canceled;
ELSE
-- status 2 - счёт был отозван => ВОЗМОЖЕН повторный экспорт
    SELECT array(SELECT txt FROM (
    SELECT 10 AS weight, cash.frontol_order_header(arg_bill_no) AS txt
    union all
    SELECT 20 AS weight, cash.frontol_order_items(arg_bill_no) AS txt
    ORDER BY weight) AS f) INTO arg_order;
        RAISE NOTICE 'arg_order=%', arg_order;
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
        RAISE NOTICE 'loc_order_host=%', arc_const(loc_const_host);
        RAISE NOTICE 'loc_order_path=%', loc_order_path;
        RAISE NOTICE 'filename=%', format('%s/order_%s.opn', loc_order_path, arg_bill_no);
        out_res := cash.sftp_text(arc_const('frontol_user'), 
            arc_const(loc_const_host),
            -- arc_const('frontol_host'),
            22, format('%s/order_%s.opn', loc_order_path, arg_bill_no), arg_order);
        RAISE NOTICE 'sftp_text completed: out_res=%', out_res;
        if out_res then
            insert into cash.receipt_queue(bill_no, cash_tag) values(arg_bill_no, arg_cash_tag)
            ON CONFLICT (bill_no, cash_tag)
            DO UPDATE
                SET status = 0,
                dt_insert = clock_timestamp(),
                dt_import = NULL,
                attempt_cnt = 0;
            out_rc := 64; -- Information
            out_text := 'Отправка на кассу прошла успешно';
        else
            RAISE NOTICE 'ERROR: out_res=%, rc=%, text=%', out_res, out_rc, out_text;
        end if;

END IF;
RAISE NOTICE 'res=%, rc=%, text=%', out_res, out_rc, out_text;

--    RETURN out_res;
end;$function$
