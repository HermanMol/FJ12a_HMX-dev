prompt *I: ScriptBOF hmx_call_stack_pks.sql
create or replace package hmx_call_stack
is
    k_spec_version    constant varchar2(20) := '2026-10-14 14:05:15';

    k_anonymous_block constant varchar2(50) := lower('__anonymous_block'); -- default, see from oracle documentation
    -- ---------------------------------------------------------------------------------------------
    -- public procedure 
    procedure pr_qdbg
        (i_msg  in varchar2
        ,i_clob in clob := null
        );

end hmx_call_stack;
/
prompt *I: ScriptEOF hmx_call_stack_pks.sql
