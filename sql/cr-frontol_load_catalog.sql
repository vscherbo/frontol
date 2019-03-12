CREATE OR REPLACE FUNCTION cash.frontol_load_catalog()
  RETURNS varchar
AS
$BODY$
DECLARE cmd character varying;
  ret_str VARCHAR := '';
  err_str VARCHAR := '';
  wrk_dir text := '/var/lib/pgsql/frontol';
BEGIN
    cmd := format('/bin/sh %s/export_catalog_frontol5_debug.sh', wrk_dir);

    IF cmd IS NULL 
    THEN 
       err_str := 'frontol_load_catalog cmd IS NULL';
       RAISE '%', err_str ; 
    END IF;

    SELECT * FROM public.exec_shell(cmd) INTO ret_str, err_str ;
    
    IF err_str IS NOT NULL
    THEN 
       RAISE 'frontol_load_catalog cmd=%^err_str=[%]', cmd, err_str; 
    END IF;
    
    return ret_str;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
