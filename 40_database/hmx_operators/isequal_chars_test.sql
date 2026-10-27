prompt *I: ScriptBOF isequal_chars_test.sql

prompt *I: Test operator isEqual (characters) - Start

with testdata as
(
    select 'a' as c1, 'a' as c2, 'A' as c3, '-' as c4
    from dual
)
select c1
    ,c2
    ,c3
    ,c4
    ,hmx_utl.f_yes_no(is_equal(c1,c2,hmx_utl.fk_case_sensitive)) as "c1?c2"
    ,hmx_utl.f_yes_no(is_equal(c1,c3,hmx_utl.fk_case_sensitive)) as "c1?c3"
    ,hmx_utl.f_yes_no(is_equal(c1,c4,hmx_utl.fk_case_sensitive)) as "c1?c4"
    ,hmx_utl.f_yes_no(is_equal(c1,c2,hmx_utl.fk_case_insensitive)) as "c1?C2"
    ,hmx_utl.f_yes_no(is_equal(c1,c3,hmx_utl.fk_case_insensitive)) as "c1?C3"
    ,hmx_utl.f_yes_no(is_equal(c1,c4,hmx_utl.fk_case_insensitive)) as "c1?C4"
from testdata
/

prompt *I: Test operator isEqual (characters) - End

prompt *I: ScriptEOF isequal_chars_test.sql
