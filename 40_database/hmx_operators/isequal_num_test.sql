prompt *I: ScriptBOF isequal_num_test.sql

prompt *I: Test operator isEqual (numbers) - Start

with testdata as
(
    select 1 as n1, 1 as n2, 3 as n3, -1 as n4
    from dual
)
select n1
    ,n2
    ,n3
    ,n4
    ,hmx_utl.f_yes_no(is_equal(n1,n2)) as "n1?n2"
    ,hmx_utl.f_yes_no(is_equal(n1,n3)) as "n1?n3"
    ,hmx_utl.f_yes_no(is_equal(n1,n4)) as "n1?n4"
from testdata
/

prompt *I: Test operator isEqual (numbers) - End

prompt *I: ScriptEOF isequal_num_test.sql
