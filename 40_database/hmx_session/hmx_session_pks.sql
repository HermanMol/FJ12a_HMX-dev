prompt *I: ScriptBOF hmx_session_pks.sql
create or replace package hmx_session
AUTHID CURRENT_USER
as
    -- Package must be AUTHID CURRENT_USER

    k_spec_version    constant varchar2(20) := '2026-10-15 15:15:10';

    -- Public types used for the pipelined function PKG_MEM_USAGE that reports the package memory
    -- usage in the current session.
    type t_pkg_mem_usage_rec is record
    (owner_name  varchar2(4000)
    ,unit_type   number(4)
    ,unit_name   varchar2(4000)
    ,used_bytes  number(15)
    ,free_bytes  number(15)
    );
    type t_pkg_mem_usage_tbl is table of t_pkg_mem_usage_rec;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Function returning the client userid taken different connections into account
    function get_client_userid return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Function returning the client IP-address either from USERENV (direct connection over tcp/ip)
    -- or from the CGI_ENV (PL/SQL gateway connection (Web)).
    function get_client_ip_address return varchar2;

    -- -----------------------------------------------------------------------------------------------
    -- Public procedure to trace what happens to session settings
    -- due to database object invoker rights vs. definer rights
    -- - AUTHID CURRENT_USER = invoker rights (a.k.a. IR)
    -- - AUTHID DEFINER      = definer rights (a.k.a. DR)
    -- ATTENTION: THIS PACKAGE MUST BE INVOKER RIGHTS or this wont report correct values!
    procedure dump_session_info
        (pi_called_from in varchar2 := null
        );

    -- ---------------------------------------------------------------------------------------------
    -- Function that reports the package memory usage in the current session.
    -- Example: select * from table(gdbutl.pkg_mem_usage)
    -- See Oracle documentation for DBMS_SESSION.GET_PACKAGE_MEMORY_UTILIZATION.
    function pkg_mem_usage
    return t_pkg_mem_usage_tbl
    pipelined;

    -- ---------------------------------------------------------------------------------------------
    -- Function that returns the item value of a context
    -- If the item value is not found in the context, the default is returned.
    -- Parameters:
    -- - pi_namespace the namespace to be found. Max VARCHAR2(30).
    -- ATTENTION: this package is INVOKER RIGHTS
    function context_exists
        (pi_namespace    in hmx_types.t_vchar30)
    return hmx_types.t_bool;

    -- ---------------------------------------------------------------------------------------------
    -- Function that returns the item value of a context
    -- If the item value is not found in the context, the default is returned.
    -- Parameters:
    -- - pi_namespace the namespace to be accessed. Max VARCHAR2(30).
    -- - pi_attribute the context item to get the value from. Max VARCHAR2(30), case-INsensitive.
    -- - pi_default   the default to be returned when the pi_attribute was not found.
    -- ATTENTION: this package is INVOKER RIGHTS
    function get_sys_context
        (pi_namespace in  hmx_types.t_vchar30
        ,pi_attribute in  hmx_types.t_vchar30
        ,pi_default   in  varchar2 := 'n/a'
        )
    return varchar2;

end hmx_session;
/
prompt *I: ScriptEOF hmx_session_pks.sql
