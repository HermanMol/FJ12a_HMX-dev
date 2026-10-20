prompt *I: ScriptBOF isequal_chars_test.sql
@hmx_spoolstart isequal_chars_test.sql
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
@hmx_spoolfinish
prompt *I: ScriptEOF isequal_chars_test.sql
