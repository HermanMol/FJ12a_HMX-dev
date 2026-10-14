create or replace procedure pr_call_stack_tests
as

    -- Efficient alias for lengthy original
    procedure prt(i_line in varchar2) as begin dbms_output.put_line(i_line); end prt;

    procedure P_04
    as
    begin
        prt('*I: Begin P_04');
        pr_call_stack('pr_call_stack');
        PRT('*i: ... blablabla ...');
        raise_application_error(-20000,'My Exception');
        prt('*I: End P_04');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            pr_call_stack('pr_call_stack');
    end P_04;

    procedure P_03
    as
    begin
        prt('*I: Begin P_03');
        pr_call_stack('pr_call_stack');
        p_04;
        prt('*I: End P_03');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            pr_call_stack('pr_call_stack');
    end P_03;

    procedure p_02
    as
    begin
        prt('*I: Begin p_02');
        pr_call_stack('pr_call_stack');
        p_03;
        prt('*I: End p_02');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            pr_call_stack('pr_call_stack');
    end p_02;

    procedure P_01
    as
    begin
        prt('*I: Begin P_01');
        pr_call_stack('pr_call_stack');
        P_02;
        prt('*I: End P_01');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            pr_call_stack('pr_call_stack');
    end P_01;

-- =========================================== MAIN LINE ===========================================
begin
    prt('*I: Begin ' || $$plsql_unit);

    begin
        pr_call_stack('pr_call_stack');
        p_01;
    exception
        when others
        then
            prt('*E: P_MAIN ' || sqlerrm );
            prt('*W: P_MAIN Exception ' || $$plsql_unit);
    end;

    prt('*I: End ' || $$plsql_unit);

exception
    when others
    then
        prt('*E: ' || sqlerrm );
        prt('*W: Exception ' || $$plsql_unit);
end pr_call_stack_tests;
/