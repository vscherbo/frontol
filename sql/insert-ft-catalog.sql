truncate table cash.frontol_catalog;
-- INSERT INTO cash.frontol_catalog(ft_code,ft_name,ft_print_name,ft_group_sign) VALUES (1, 'КИПиА', 'КИПиА', 0);

WITH arc2ft AS (SELECT c."КодСодержания" ks
, substring(
            format('%s %s', 
                    c."КодСодержания", regexp_replace(regexp_replace("НазваниевСчет", '\n', ' ', 'g'), ';', '¤', 'g')
                  ) 
            from 1 for 128) ft_name
, p."ОтпускнаяЦена"::numeric ft_price
FROM "Содержание" c
join "vwЦены" p on p."КодСодержания" = c."КодСодержания" 
where "Активность"
ORDER BY c."КодСодержания"
-- limit 10
)
INSERT INTO cash.frontol_catalog(ft_code,ft_barcode,ft_name,ft_print_name,ft_price) (
SELECT ks, ks, ft_name, ft_name, ft_price FROM arc2ft
);
