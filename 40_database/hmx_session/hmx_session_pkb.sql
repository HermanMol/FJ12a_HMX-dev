prompt *I: ScriptBOF hmx_session_pkb.sql
create or replace package body hmx_session
as
-- package must be AUTHID CURRENT_USER

    k_body_version varchar2(20) := '2026-10-15 15:14:58';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic
    as
    begin
        return 'Package ' || $$plsql_unit || ' version' || ': Spec='  || k_spec_version || ', Body='  || k_body_version;
    end get_version_info;

    -- -----------------------------------------------------------------------------------------------
    -- Public procedure to trace what happens to session settings
    -- due to database object invoker rights vs. definer rights
    -- - AUTHID CURRENT_USER = invoker rights (a.k.a. IR)
    -- - AUTHID DEFINER      = definer rights (a.k.a. DR)
    -- ATTENTION: THIS PACKAGE MUST BE INVOKER RIGHTS or this wont report correct values!
    procedure dump_session_info
        (pi_called_from in varchar2 := null
        )
    as
    begin
        dbms_output.enable(null);
        dbms_output.put_line('*X: ' || $$PLSQL_UNIT || '.DUMP_SESSION_INFO' || nullif('<-' || pi_called_from, '<-')
            || chr(10) || '- USER............. =' || nvl(to_char(USER                                      ),'n/a')
            || chr(10) || '- CURRENT_SCHEMA... =' || nvl(to_char(sys_context('USERENV','CURRENT_SCHEMA'   )),'n/a')
            || chr(10) || '- CURRENT_USER..... =' || nvl(to_char(sys_context('USERENV','CURRENT_USER'     )),'n/a')
            || chr(10) || '- SESSION_USER..... =' || nvl(to_char(sys_context('USERENV','SESSION_USER'     )),'n/a')
            || chr(10) || '- OS_USER.......... =' || nvl(to_char(sys_context('USERENV','OS_USER'          )),'n/a')
            || chr(10) || '- CLIENT_IDENTIFIER =' || nvl(to_char(sys_context('USERENV','CLIENT_IDENTIFIER')),'n/a')
            || chr(10) || '- CLIENT_INFO...... =' || nvl(to_char(sys_context('USERENV','CLIENT_INFO')      ),'n/a')
            || chr(10) || '- CLIENT_USER(utl). =' || nvl(to_char(get_client_userid                         ),'n/a')
            );
    end dump_session_info;

    -- ---------------------------------------------------------------------------------------------
    -- Function returning the client userid taken different connections into account
    function get_client_userid
    return varchar2
    as
        l_user varchar2(100);
        l_try_others varchar2(32767) := 'APEX_PUBLIC_USER;SYS;SYSTEM;NOBODY;ORACLE';
    begin
        if sys_context('USERENV','SESSION_USER') = 'APEX_PUBLIC_USER'
        then
            l_user := v('APP_USER');  -- only works when APEX is installed!
        else
            l_user := substr(regexp_substr(sys_context('USERENV','CLIENT_IDENTIFIER'),'^(\w+):',1,1,'i',1),1,64);
        end if;

        if instr(l_try_others,nvl(upper(l_user),'NOBODY') ) > 0
        then
            l_user := sys_context('USERENV','CURRENT_SCHEMA');
            if instr(l_try_others,nvl(upper(l_user),'NOBODY') ) > 0
            then
                l_user := sys_context('USERENV','SESSION_USER');
                if instr(l_try_others,nvl(upper(l_user),'NOBODY') ) > 0
                then
                    l_user := sys_context('USERENV','OS_USER');
                end if;
            end if;
        end if;

        return l_user;

    end get_client_userid;

    -- ---------------------------------------------------------------------------------------------
    -- Function returning the client IP-address either from USERENV (direct connection over tcp/ip)
    -- or from the CGI_ENV (PL/SQL gateway connection (Web)).
    function get_client_ip_address
    return varchar2
    as
    begin
        if owa.num_cgi_vars is not null
        then
            -- PL/SQL gateway connection (WEB client)
            return owa_util.get_cgi_env ('REMOTE_ADDR') || nullif(',' || owa_util.get_cgi_env ('X-FORWARDED-FOR'), ',');
        else
            -- Direct connection over tcp/ip network
            return sys_context ('USERENV', 'IP_ADDRESS');
        end if;
    end get_client_ip_address;

    -- ---------------------------------------------------------------------------------------------
    -- Function that reports the package memory usage in the current session.
    -- See Oracle documentation for DBMS_SESSION.GET_PACKAGE_MEMORY_UTILIZATION.
    function pkg_mem_usage
    return t_pkg_mem_usage_tbl
    pipelined
    as
        l_owner_names       dbms_session.lname_array;
        l_unit_names        dbms_session.lname_array;
        l_unit_types        dbms_session.integer_array;
        l_used_amounts      dbms_session.integer_array;
        l_free_amounts      dbms_session.integer_array;
        l_pkg_mem_usage_rec t_pkg_mem_usage_rec;
    begin
        dbms_session.get_package_memory_utilization
            (owner_names  => l_owner_names  -- out
            ,unit_names   => l_unit_names   -- out
            ,unit_types   => l_unit_types   -- out = Value of the type# columns of the dictionary table obj$
            ,used_amounts => l_used_amounts -- out = Amount of allocated memory specified in bytes
            ,free_amounts => l_free_amounts -- out = Amount of available memory specified in bytes
            );
        <<all_entries>>
        if l_owner_names.count > 0
        then
            for idx in l_owner_names.first .. l_owner_names.last
            loop
                l_pkg_mem_usage_rec.owner_name  := l_owner_names (idx);
                l_pkg_mem_usage_rec.unit_type   := l_unit_types  (idx);
                l_pkg_mem_usage_rec.unit_name   := l_unit_names  (idx);
                l_pkg_mem_usage_rec.used_bytes  := l_used_amounts(idx);
                l_pkg_mem_usage_rec.free_bytes  := l_free_amounts(idx);
                pipe row(l_pkg_mem_usage_rec);
            end loop all_entries;
        end if;
        return;
    end pkg_mem_usage;

    -- ---------------------------------------------------------------------------------------------
    -- Function that returns the item value of a context
    -- If the item value is not found in the context, the default is returned.
    -- Parameters:
    -- - pi_namespace the namespace to be found. Max VARCHAR2(30).
    -- ATTENTION: this package is INVOKER RIGHTS
    function context_exists
        (pi_namespace    in hmx_types.t_vchar30)
    return hmx_types.t_bool
    as
        l_appctxtab   dbms_session.appctxtabtyp;
        l_size        number;
        l_retval      hmx_types.t_bool := hmx_utl.k_false;
    begin
        dbms_session.list_context 
            (list  => l_appctxtab    -- out
            ,lsize => l_size         -- out
            );
        if l_size > 0
        then
            <<process_context_list>>
            for idx in 1 .. l_size
            loop
                if upper(pi_namespace) = upper(l_appctxtab(idx).namespace)
                then
                    l_retval := hmx_utl.k_false;
                    exit process_context_list;
                end if;
            end loop process_loop_context_list;
        end if;
        return l_retval;
    end context_exists;

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
    return varchar2
    as
        l_retval    hmx_types.t_vchar4000;
    begin
        return sys_context(pi_namespace, pi_attribute, 4000);
    exception
        when others
        then
            dbms_output.put_line ('*E: invalid item "' || pi_attribute || '" for context ' || pi_namespace|| '.');
            if sqlcode = -2003
            then
                return pi_default;
            end if;
            raise;
    end get_sys_context;

end hmx_session;
/
prompt *I: ScriptEOF hmx_session_pkb.sql
