create or replace package ut_hmx_session
is
-- Created using copilot 2026-11-09 16:56:07

    -- %suite(HMX_SESSION)

    -- %test(Get client userid returns a value)
    procedure get_client_userid_ok;

    -- %test(Get client ip address does not fail)
    procedure get_client_ip_ok;

    -- %test(USERENV context exists)
    procedure context_exists_userenv;

    -- %test(Unknown context does not exist)
    procedure context_exists_unknown;

    -- %test(Get session user context)
    procedure get_session_user;

    -- %test(Get context returns default for invalid attribute)
    procedure get_context_default;

    -- %test(Package memory usage query works)
    procedure pkg_mem_usage_ok;

    -- %test(Dump session info executes)
    procedure dump_session_info_ok;
end ut_hmx_session;
/