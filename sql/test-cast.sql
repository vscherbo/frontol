-- CREATE TYPE t_test AS (t1 text, t2 text, i1 integer, n1 numeric);
SELECT 
('(,, 0, 2488)'::t_test).n1
, (('(' || ft_tail || ')') ::t_test).n1
, (format('(%s)',ft_tail)::t_test).n1
-- , t_test(format('(%s)',ft_tail))
FROM arc_energo.frontol_trans WHERE ft_type = 99
