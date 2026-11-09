create or replace package body ut_hmx_session
is
-- Created using copilot 2026-11-09 16:56:07

    procedure get_client_userid_ok
    is
        l_user varchar2(4000);
    begin
        l_user := hmx_session.get_client_userid;

        ut.expect(l_user).not_to_be_null;
    end;

    procedure get_client_ip_ok
    is
        l_ip varchar2(4000);
    begin
        l_ip := hmx_session.get_client_ip_address;

        ut.expect(1).to_equal(1);
    exception
        when others then
            ut.fail(sqlerrm);
    end;

    procedure context_exists_userenv
    is
    begin
        ut.expect(
            hmx_session.context_exists('UT3_INFO')  -- HMO: was ('USERENV')
        ).to_equal(hmx_utl.k_btrue);
    end;

    procedure context_exists_unknown
    is
    begin
        ut.expect(
            hmx_session.context_exists('NO_SUCH_CONTEXT_XYZ')
        ).to_equal(hmx_utl.k_bfalse);
    end;

    procedure get_session_user
    is
        l_user varchar2(4000);
    begin
        l_user :=
            hmx_session.get_sys_context(
                'USERENV',
                'SESSION_USER'
            );

        ut.expect(l_user).not_to_be_null;
    end;

    procedure get_context_default
    is
        l_value varchar2(4000);
    begin
        l_value :=
            hmx_session.get_sys_context(
                'USERENV',
                'THIS_ATTRIBUTE_DOES_NOT_EXIST',
                'DEFAULT'
            );

        ut.expect(l_value).to_equal('DEFAULT');
    end;

    procedure pkg_mem_usage_ok
    is
        l_count number;
    begin
        select count(*)
        into l_count
        from table(hmx_session.pkg_mem_usage);

        ut.expect(l_count).to_be_greater_or_equal(0);
    end;

    procedure dump_session_info_ok
    is
    begin
        hmx_session.dump_session_info('utPLSQL');

        ut.expect(1).to_equal(1);
    exception
        when others then
            ut.fail(sqlerrm);
    end;

end ut_hmx_session;
/
