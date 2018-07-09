\echo '##@@&&'
\echo '#'
\echo '$$$REPLACEQUANTITY'

\copy (SELECT ft_code, ft_barcode, substring(ft_name from 1 for 100), substring(ft_print_name from 1 for 100), to_char(ft_price, 'FM9999999D99'), to_char(ft_quantity, 'FM9999999D99'), ft_filler07, ft_flags, ft_min_price, ft_filler10, ft_scheme_code, ft_variant, ft_item_type, ft_barcode_coeff, ft_filler15, ft_parent_group_code, ft_group_sign, ft_payment_type, ft_filler19, ft_series, ft_certificate, ft_filler22, ft_tax_group_code, ft_filler24 FROM cash.frontol_catalog ORDER BY ft_code) to STDOUT with (format 'csv', delimiter ';', header False)
