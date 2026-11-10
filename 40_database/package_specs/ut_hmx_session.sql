create or replace package ut_hmx_session
is
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Unit Test HMX_SESSION

.HMX_OBJECT_NOTES:
    Created using copilot 2026-11-09 16:56:07 and some modifications

.HMX_DEVELOPER_NOTES:
    - See HMX General Developer Notes

.HMX_OBJECT_VERSION: 2026-11-10 10:39:55 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

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