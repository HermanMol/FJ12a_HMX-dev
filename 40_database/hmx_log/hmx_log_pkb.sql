prompt *I: ScriptBOF hmx_log_pkb.sql
create or replace package body hmx_log
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: This package/script...

.HMX_OBJECT_NOTES:
    Package must be invoker rights (AUTHID CURRENT_USER)
    ...

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-24 16:38:10 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */-- package must be AUTHID CURRENT_USER


    -- Private constants related to this package body, (s_ = SELF)
    k_anonymous  constant varchar2(50) := lower('__anonymous_block');   -- default from Oracle documentation
    k_pkg_init   constant varchar2(50) := upper('__pkg_init');          -- the Oracle defined name for the package initialization
    k_1_second   constant number       := 1;
    k_nill       constant varchar2(4)  := 'Nill';                       -- to differ from the standard NULL
    k_lf         constant varchar2(1)  := hmx_utl.k_lf;                 -- ASCII Line Feed
    k_1q         constant varchar2(1)  := hmx_utl.k_1q;                 -- ASCII single quote

    k_max_log_rate_default constant number := 50;

    -- Private global variables
    -- Private stack to cache messages e.g. to log in case of an exception.
    s_msg_stack         string_stack_type := string_stack_type();

    -- to hold a unique value per session and which is that is logged with the message.
    s_process_id        hmx_log_data.log_process%type;

    s_minimum_log_level number                              := fk_attention;
    s_app_user          hmx_log_data.log_app_user%type := null;
    s_tags              hmx_log_data.log_tags%type     := null;

    -- Private variables: keep track of the log rate per second, no more than ...
    s_last_logtime      timestamp(9) with time zone;
    s_cnt_msg_written   number(38,0) :=  0;
    s_cnt_msg_skipped   number(38,0) :=  0;
    s_max_log_rate      number(6,0)  := k_max_log_rate_default;

    -- Public constants implemented as functions so they can be used in queries.
    -- Log message level, predefined constants
    -- For Message Types TRACE and DEBUG the logged level will be negative and indicate at which
    -- call stack level the log message was issued.
    function fk_no_level    return number   deterministic is begin return k_no_level ; end;  -- default
    function fk_cache       return number   deterministic is begin return k_cache    ; end;  -- cache the message i.s.o. immediately writing it to the log table
    function fk_normal      return number   deterministic is begin return k_normal   ; end;
    function fk_attention   return number   deterministic is begin return k_attention; end;
    function fk_warning     return number   deterministic is begin return k_warning  ; end;
    function fk_error       return number   deterministic is begin return k_error    ; end; -- possible to recover/continue
    function fk_severe      return number   deterministic is begin return k_severe   ; end; -- more serious error that just an error
    function fk_critical    return number   deterministic is begin return k_critical ; end; -- unrecoverable, abort processing
    function fk_force       return number   deterministic is begin return k_force    ; end; -- just force log without any other reason
    -- Log message type, predefined constants
    -- INFO/TECH/FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY
    function fk_info        return varchar2 deterministic is begin return k_info    ; end;  -- default
    function fk_tech        return varchar2 deterministic is begin return k_tech    ; end;
    function fk_func        return varchar2 deterministic is begin return k_func    ; end;
    function fk_trace       return varchar2 deterministic is begin return k_trace   ; end;
    function fk_debug       return varchar2 deterministic is begin return k_debug   ; end;
    function fk_develop     return varchar2 deterministic is begin return k_develop ; end;
    function fk_testing     return varchar2 deterministic is begin return k_testing ; end;
    function fk_auditing    return varchar2 deterministic is begin return k_auditing; end;
    function fk_security    return varchar2 deterministic is begin return k_security; end;
    function fk_logging     return varchar2 deterministic is begin return k_logging ; end; -- internally hmx_log usage
    -- Log message scope, predefined constants
    -- DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER
    function fk_anyone      return varchar2 deterministic is begin return k_anyone    ; end;  -- default
    function fk_developer   return varchar2 deterministic is begin return k_developer ; end;
    function fk_tester      return varchar2 deterministic is begin return k_tester    ; end;
    function fk_admin       return varchar2 deterministic is begin return k_admin     ; end;
    function fk_operations  return varchar2 deterministic is begin return k_operations; end;
    function fk_user        return varchar2 deterministic is begin return k_user      ; end;
    function fk_keyuser     return varchar2 deterministic is begin return k_keyuser   ; end;

    -- ---------------------------------------------------------------------------------------------
    -- TODO
    procedure set_last_logtime
    as
    begin
        s_last_logtime := systimestamp at time zone 'UTC';
    end set_last_logtime;

    -- ---------------------------------------------------------------------------------------------
    -- TODO
    function get_last_logtime
    return timestamp with time zone
    as
    begin
        return s_last_logtime;
    end get_last_logtime;

  -- -----------------------------------------------------------------------------------------------
  -- Package private function to initialise the hmx_log_data record
  procedure bp_init_hmx_log_data_record
    (pio_hmx_log_rec in out hmx_log_data%rowtype
    )
  as
  begin
    pio_hmx_log_rec := null;
    pio_hmx_log_rec.log_type       := fk_logging;
    pio_hmx_log_rec.log_level      := fk_no_level;
    pio_hmx_log_rec.log_scope      := fk_developer;
    pio_hmx_log_rec.log_tags       := null;
    pio_hmx_log_rec.log_msg        := null;
    pio_hmx_log_rec.log_time       := systimestamp at time zone 'UTC';
    pio_hmx_log_rec.log_process    := s_process_id;
    pio_hmx_log_rec.log_sesid      := sys_context('userenv','sessionid');
    pio_hmx_log_rec.log_server     := sys_context('userenv','server_host');
    pio_hmx_log_rec.log_dbname     := sys_context('userenv','db_name');
    pio_hmx_log_rec.log_dbschema   := sys_context('userenv','current_schema');
    pio_hmx_log_rec.log_dbuser     := sys_context('userenv','session_user');
    pio_hmx_log_rec.log_osuser     := sys_context('userenv','os_user');
    pio_hmx_log_rec.log_app_user   := get_app_user;
    pio_hmx_log_rec.log_org_owner  := $$plsql_unit_owner;
    pio_hmx_log_rec.log_org_object := $$plsql_unit;
    pio_hmx_log_rec.log_org_type   := null;
    pio_hmx_log_rec.log_org_method := 'BP_INIT_hmx_log_DATA_RECORD';
    pio_hmx_log_rec.log_org_line   := $$plsql_line;
    pio_hmx_log_rec.log_call_depth := 0;
  end bp_init_hmx_log_data_record;

  -- -----------------------------------------------------------------------------------------------
  -- Private function that calls the actual insert in hmx_log_DATA
  function bf_insert_hmx_log_data
    (pi_hmx_log_rec in hmx_log_data%rowtype
    )
  return number
  as
    l_log_id  number;
  begin
    -- insert the logging into the hmx_log_DATA table
    l_log_id := hmx_log_core.insert_hmx_log_data(pi_hmx_log_rec);
    set_last_logtime; -- to control the maximum logging per second
    return l_log_id;
  end bf_insert_hmx_log_data;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to construct a private process_id
  procedure bp_generate_process_id
  is
  begin
    if sys_context('USERENV','SESSION_USER') = 'APEX_PUBLIC_USER'
    then
      -- use the APEX data that we can re-construct and relate to an APEX Session
      s_process_id := lower('APEX'
                            || ';' || to_char(sysdate,'yyyymmdd')
                            || ';' || v('APP_SESSION')
                            || ';' || v('APP_USER')
                            );
    else
      -- some supposed-to-be-unique string
      s_process_id := lower('GUID'
                            || ';' || to_char(sysdate,'yyyymmdd')
                            || ';' || sys_guid()
                            || ';' || sys_context('USERENV','SID')
                            );
    end if;
  end bp_generate_process_id;

  -- ---------------------------------------------------------------------------------------------
  -- Package private procedure to initialise this package. Supposed to be executed when package is
  -- instantiated the first time it is called in a database session.
  procedure bp_init_package
  is
  begin

    bp_generate_process_id();
    set_last_logtime;
    set_app_user;
    --hmx_log_ctx_api.set_minimum_log_level(pi_value => fk_normal);
    s_minimum_log_level := fk_normal;
    s_max_log_rate      := k_max_log_rate_default;

  end bp_init_package;

  -- -----------------------------------------------------------------------------------------------
  -- private function that returns the last issued hmx_log_data sequence
  function bf_get_last_log_seq
  return number
  as
    l_last_seq  number;
  begin
    select max(log_pkid) into l_last_seq from hmx_log_data;
    return nvl(l_last_seq,-1);
  end bf_get_last_log_seq;

  -- ---------------------------------------------------------------------------------------------
  -- Public function get the log level active in this session
  function get_minimum_log_level
  return number
  as
  begin
    return s_minimum_log_level;
  end get_minimum_log_level;

  -- -----------------------------------------------------------------------------------------------
  -- Public procedure set the log level active in this session
  procedure set_minimum_log_level
    (pi_log_level in number := null
    )
  is
  begin
        s_minimum_log_level := coalesce
                                  (pi_log_level
                                  ,k_normal
                                  );
  end set_minimum_log_level;

  -- ---------------------------------------------------------------------------------------------
  -- Get the tags
  function get_tags
  return varchar2
  as
  begin
    return s_tags;
  end get_tags;

  -- ---------------------------------------------------------------------------------------------
  -- Set the logging tags
  procedure set_tags
    (pi_tags      in varchar2
    )
  as
  begin
     s_tags := pi_tags;
  end set_tags;

  -- ---------------------------------------------------------------------------------------------
  -- Get the app_user
  function get_app_user
  return varchar2
  as
  begin
    return s_app_user;
  end get_app_user;

  -- ---------------------------------------------------------------------------------------------
  -- Set the app_user.
  -- For APEX this will always be the APP_USER unless pi_from_sys is set to false.
  -- For non-APEX this will be a value that is expected to be in the session CLIENT_INFO in a
  -- predefined format, also unless pi_from_sys is set to false.
  procedure set_app_user
    (pi_app_user  in varchar2 := null
    ,pi_from_sys  in boolean  := true
    )
  as
    l_client_info varchar2(64);
  begin
    if  sys_context('USERENV','SESSION_USER') = 'APEX_PUBLIC_USER'
    and pi_from_sys = true
    then
      -- execute immediate('select v(''APP_USER'') from dual') into s_app_user;
      s_app_user := v('APP_USER');
    else
      l_client_info := sys_context('USERENV','CLIENT_INFO');
      -- SEE, DEPENDS ON CLE0901F.SEL_VRLE SETTING THE  dbms_application_info.set_client_info (client_info => !!
      if  regexp_count(l_client_info,'^ingelogd met relatienummer: [0-9]{3,10}',1,'c') <> 0
      and pi_from_sys = true
      then
        s_app_user := regexp_substr(l_client_info,'^ingelogd met relatienummer: ([0-9]{3,10})',1,1,'c',1);
      else
        s_app_user := nvl(pi_app_user, user);
      end if;
    end if;
  end set_app_user;

  -- ---------------------------------------------------------------------------------------------
  -- Get the maximum logged messages per second
  -- When the process exceeds this number, ALL logging is suppressed
  function get_max_log_rate
  return number
  as
  begin
    return s_max_log_rate;
  end get_max_log_rate;

  -- ---------------------------------------------------------------------------------------------
  -- Set the maximum logged messages per second
  -- When the process exceeds this number, ALL logging is suppressed
  -- The returned number is the old value.
  -- Allowed values for pi_rate: between 1 and 1000 (inclusive). When an
  -- invalid value is specified the default messages / second is used.
  function set_max_log_rate
    (pi_rate  in number := null)
  return number
  as
    l_old_rate  number;
  begin
    l_old_rate := s_max_log_rate;
    if pi_rate between 1 and 1000
    then
      s_max_log_rate := pi_rate;
    else
      s_max_log_rate := k_max_log_rate_default;
    end if;
    -- reset settings
    set_last_logtime;
    s_cnt_msg_written := 0;

    return l_old_rate;
  end set_max_log_rate;

  -- ---------------------------------------------------------------------------------------------
  -- Function returning the current process_id
  function get_process_id
  return varchar2
  as
  begin
    return s_process_id;
  end get_process_id;

  -- ---------------------------------------------------------------------------------------------
  -- Function setting a new process_id and returning the new process_id
  function new_process_id
  return varchar2
  as
  begin
    bp_generate_process_id();
    return s_process_id;
  end new_process_id;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to set the private process_id with a custom value
  -- Example: testrun_2023-05-15T14:52:22
  -- The (internal) process_id is automatically set to some GUID when this package is instantiated.
  procedure set_process_id
    (pi_process_id in varchar2)
  is
  begin
    s_process_id := substr(pi_process_id, 1, 100);
  end set_process_id;

  -- ---------------------------------------------------------------------------------------------
  -- public
  -- Log the message
  -- All values SUBSTR-ed - better safe than sorry
  -- - pi_type  = The type of message. Unrestricted but these are the predefined values:
  --              (default) INFO, TECH, FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY.
  -- - pi_level = The severity level of the message: (default) 0=not_specified, 5=cache, 10=info,
  --              15=attention, 20=warning, 25=error, 30=severe, 35=critical
  --              For types TRACE and DEBUG a negative value indicates the execution level at
  --              which the message was issued. Unrestricted.
  -- - pi_scope = The scope of the message, Unrestricted but these are the predefined values:
  --              DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER and (default) ANYONE.
  -- - pi_tags  = Free format for tags for logical grouping of messages, e.g. a test case
  --              reference or a REST message UID.
  -- - pi_log_opt: Logging options
  --    SQLCode | Force | Call_Stack | Error_Backtrace | Result      | Call_Stack | Error_Stack
  --    <>0     | *1    |    n/a     |    n/a          | log message | yes        | yes
  --    =0      | n/a   |    false   |    false        | log message | no         | no
  --    =0      | n/a   |    false   |    true         | log message | no         | yes
  --    =0      | n/a   |    true    |    false        | log message | yes        | no
  --    =0      | n/a   |    true    |    true         | log message | yes        | yes
  --  *1 = if force=true then will log even when the error is in this hmx_log-package itself, so
  --       this should not be used when called from another package. TYPE will be set to LOGGING
  procedure log_msg
    (pi_msg         in varchar2
    ,pi_level       in number   := fk_no_level
    ,pi_type        in varchar2 := fk_info
    ,pi_scope       in varchar2 := fk_anyone
    ,pi_tags        in varchar2 := null
    ,pi_log_opt     in number   := 0
    ,pi_object_type in varchar2 := null
    )
  is
    l_in_exception_handling varchar2(1) := hmx_utl.k_no;
    l_called_from_info      hmx_call_stack.t_called_from_info_rec;
    l_hmx_log_rec           hmx_log_data%rowtype;
    l_log_id                number;
    l_now                   timestamp(9) with time zone;
    l_since                 number(11,2);
    l_logging_msg           hmx_log_data.log_msg%type := null;
    l_log_opt               pls_integer;  -- initially pi_log_opt but might be changed.
    l_minimum_level         varchar2(10);
    l_log_type              hmx_log_data.log_type%type := null;
    l_txt_cached_msg        varchar2(4000) := null;

  begin

    bp_init_hmx_log_data_record(l_hmx_log_rec);

    if sqlcode <> 0
    then
      l_in_exception_handling := hmx_utl.k_yes;
    end if;

    -- prevent a nasty looping :-) when called from gdb_tools.hmx_log_ctx_api.log_context_values
    -- only needed during development of this perticular package
    -- *skip     if  not (   pi_type = fk_logging
    -- *skip             and pi_tags = 'LOG_CONTEXT_VALUES'
    -- *skip             )
    -- *skip     then
    -- *skip       gdb_tools.hmx_log_ctx_api.log_context_values(pi_text => 'LOG_MSG');
    -- *skip     end if;

    l_log_opt := pi_log_opt;    -- TODO

    l_called_from_info := hmx_call_stack.get_called_from_details(i_skip_units => $$plsql_unit);
    l_hmx_log_rec.log_msg             := pi_msg;
    l_hmx_log_rec.log_type            := pi_type;
    l_hmx_log_rec.log_level           := pi_level;
    l_hmx_log_rec.log_scope           := pi_scope;
    l_hmx_log_rec.log_tags            := pi_tags;
    l_hmx_log_rec.log_org_owner       := l_called_from_info.object_owner;
    l_hmx_log_rec.log_org_object      := l_called_from_info.object_name;
    l_hmx_log_rec.log_org_method      := l_called_from_info.object_method;
    l_hmx_log_rec.log_org_line        := l_called_from_info.object_line;
    l_hmx_log_rec.log_call_depth      := l_called_from_info.call_depth;
    
    if l_in_exception_handling = hmx_utl.k_yes
    then
      l_hmx_log_rec.log_sqlcode := sqlcode;
      l_hmx_log_rec.log_sqlerrm := substr(sqlerrm,1,512);
      if bitand(l_log_opt,k_log_error_backtrace) = 0
      then
        l_log_opt := l_log_opt + k_log_error_backtrace;
      end if;
      if bitand(l_log_opt,k_log_call_stack) = 0
      then
        l_log_opt := l_log_opt + k_log_call_stack;
      end if;
    end if;

    if bitand(l_log_opt,k_log_error_backtrace) = k_log_error_backtrace
    then
      l_hmx_log_rec.log_error_backtrace := nvl(substr(dbms_utility.format_error_backtrace(),1,4000),'(none)');
    end if;
    if bitand(l_log_opt,k_log_call_stack) = k_log_call_stack
    then
      l_hmx_log_rec.log_call_stack := nvl(substr(dbms_utility.format_call_stack(),1,4000),'(none)');
    end if;

    -- The object_type is not available in the UTL_CALL_STACK data ...
    -- But we need it for SQL Developer SDEV_LINK_TYPE ...
    if l_hmx_log_rec.log_org_type is null
    then
        <<get_object_type>>
        begin
            select object_type
            into l_hmx_log_rec.log_org_type
            from all_objects
            where oracle_maintained = 'N'
            and owner       = l_hmx_log_rec.log_org_owner 
            and object_name = l_hmx_log_rec.log_org_object
            and object_type in ('PACKAGE','PACKAGE BODY', 'TRIGGER', 'PROCEDURE', 'FUNCTION')
            order by object_type desc
            fetch first 1 rows only;
        exception
            when no_data_found
            then
                l_hmx_log_rec.log_org_type := '-';
        end get_object_type;
    end if;
    -- insert the logging into the hmx_log_DATA table
    l_log_id := bf_insert_hmx_log_data(l_hmx_log_rec);

    if l_logging_msg is not null    -- TODO what is this for
    then
      l_hmx_log_rec.log_msg  := l_logging_msg || ' (after log_pkid =' || to_char(l_log_id) || ')';
      l_hmx_log_rec.log_type := fk_logging;
      l_log_id := bf_insert_hmx_log_data(l_hmx_log_rec);
    end if;

  end log_msg;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to initialize the cached message stack.
  procedure clear_cached_msg
  as
  begin
        s_msg_stack.init_stack();
  end clear_cached_msg;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to add a message to the message stack for possible later print
  procedure cache_msg (pi_msg in varchar2)
  as
  begin
        s_msg_stack.push(pi_msg);
  end cache_msg;

  -- ---------------------------------------------------------------------------------------------
  -- Function to retrieve all cached messages (separated by LF) in a string, maximum 32767 characters.
  -- pi_flush, when yes then the stack will be cleared after the messages have been retrieved.
  -- pi_max_length:
  -- - null    = no max, all is returned (max 32767 characters, default from start of the messages)
  -- - 0(zero) = NULL string is returned
  -- - >0      = maximum characters from begin (position 1) of the string of serialized cached messages
  -- - <0      = maximum characters from END of the string of serialized cached messages
  -- When the messages are truncated an ellipsis (...) is added in the begin or the end.
  function get_cached_msg
    (pi_flush      in varchar2 := hmx_utl.k_no
    ,pi_max_length in number   := null
    )
  return varchar2
  as
    l_all_msg_txt           clob := empty_clob();
    l_all_msg_len           number;
    l_rtn_msg_txt           varchar2 (32767);
    c_max_length  constant  number := 32767; -- never more than definition of l_rtn_msg_txt
    l_max_chars             number := 0;
    l_offset                number := 0;
  begin
    if pi_max_length = 0
    then
      return null;
    end if;

    l_all_msg_txt := s_msg_stack.get_serialized();
    l_all_msg_len := nvl(dbms_lob.getlength(l_all_msg_txt),0);
    if l_all_msg_txt = 'No strings in string_stack_type.'
    or l_all_msg_len = 0
    then
      -- no messages in the cache.
      return null;
    end if;

    l_max_chars   := greatest(c_max_length, abs(nvl(pi_max_length,0)) );
    l_all_msg_len := dbms_lob.getlength(l_all_msg_txt);

    if l_max_chars >= l_all_msg_len
    then  -- past er helemaal in
      l_rtn_msg_txt := l_all_msg_txt;
    else
      -- too many characters in all messages. Take part from begin or from end of messages (incl ellipsis)
      l_max_chars := l_max_chars - length(hmx_utl.k_ellipsis);
      if nvl(pi_max_length,1) > 0
      then
        -- from the begin
        l_offset := 1;
        l_rtn_msg_txt := dbms_lob.substr
                          (lob_loc  => l_all_msg_txt
                          ,amount   => l_max_chars
                          ,offset   => l_offset
                          )
                        || hmx_utl.k_ellipsis;
      else
        -- from the end
        l_offset := l_all_msg_len - l_max_chars;
        l_rtn_msg_txt := hmx_utl.k_ellipsis
                          || dbms_lob.substr
                              (lob_loc  => l_all_msg_txt
                              ,amount   => l_max_chars
                              ,offset   => l_offset
                              );
      end if;
    end if;

    if upper(pi_flush) = hmx_utl.k_yes
    then
      clear_cached_msg;
    end if;

    return l_rtn_msg_txt;
  end get_cached_msg;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure that logs connection values
  procedure log_connection
  is
    l_text    varchar2(32767);

    -- If APEX not available in the database the V-function is unknown so we use dynamic SQL
    function lf_get_apex_values(pi_variable_name in varchar2)
    return varchar2
    as
      l_line  varchar2(32767) := null;
      l_sql   varchar2(32767);
    begin
      if sys_context('USERENV','SESSION_USER') = 'APEX_PUBLIC_USER'
      then
        l_sql := 'select '
            || k_1q || k_lf || '- ' || pi_variable_name || '='  || k_1q
            || ' || v(' || k_1q || pi_variable_name || k_1q|| ')'
            || ' from dual'
            ;
        execute immediate(l_sql) into l_line;
      end if;
      return l_line;
    exception
      when others
      then
        log_msg
          (pi_msg     => '*E While executing dynamic SQL: ' || replace(nvl(l_sql,k_nill),k_lf,null)
          ,pi_type    => fk_logging
          ,pi_level   => fk_error
          ,pi_scope   => fk_developer
          ,pi_log_opt => k_log_call_stack + k_log_error_backtrace + k_force_logging
          ,pi_tags    => 'APEX_ERROR'
          );
    end lf_get_apex_values;

  -- LOG_CONNECTION - MAIN
  begin

    l_text := 'USERENV:'
      || k_lf || '- HOST='                   || nvl(sys_context('USERENV','HOST'),k_nill)
      || k_lf || '- IP_ADDRESS='             || nvl(sys_context('USERENV','IP_ADDRESS'),k_nill)
      || k_lf || '- OS_USER='                || nvl(sys_context('USERENV','OS_USER'),k_nill)
      || k_lf || '- AUTHENTICATED_IDENTITY=' || nvl(sys_context('USERENV','AUTHENTICATED_IDENTITY'),k_nill)
      || k_lf || '- AUTHENTICATION_METHOD='  || nvl(sys_context('USERENV','AUTHENTICATION_METHOD'),k_nill)
      || k_lf || '- CURRENT_SCHEMA='         || nvl(sys_context('USERENV','CURRENT_SCHEMA'),k_nill)
      || k_lf || '- CURRENT_USER='           || nvl(sys_context('USERENV','CURRENT_USER'),k_nill)
      || k_lf || '- SESSION_USER='           || nvl(sys_context('USERENV','SESSION_USER'),k_nill)
      || k_lf || '- NLS_TERRITORY='          || nvl(sys_context('USERENV','NLS_TERRITORY'),k_nill)
      || k_lf || '- LANGUAGE='               || nvl(sys_context('USERENV','LANGUAGE'),k_nill)
      || k_lf || '- LANG='                   || nvl(sys_context('USERENV','LANG'),k_nill)
      || k_lf || '- NLS_DATE_LANGUAGE='      || nvl(sys_context('USERENV','NLS_DATE_LANGUAGE'),k_nill)
      || k_lf || '- NLS_CALENDAR='           || nvl(sys_context('USERENV','NLS_CALENDAR'),k_nill)
      || k_lf || '- NLS_DATE_FORMAT='        || nvl(sys_context('USERENV','NLS_DATE_FORMAT'),k_nill)
      || k_lf || '- NLS_CURRENCY='           || nvl(sys_context('USERENV','NLS_CURRENCY'),k_nill)
      || k_lf || '- SERVER_HOST='            || nvl(sys_context('USERENV','SERVER_HOST'),k_nill)
      || k_lf || '- DB_UNIQUE_NAME='         || nvl(sys_context('USERENV','DB_UNIQUE_NAME'),k_nill)
      || k_lf || '- MondayWeekDayNr='        || to_char(to_date('20120625','yyyymmdd'),'d')
      || k_lf || '- DecimalPoint='           || to_char((1234567890/100),'99g999g990d999')
      || k_lf || '- MODULE='                 || nvl(sys_context('USERENV','MODULE'),k_nill)
      || k_lf || '- ACTION='                 || nvl(sys_context('USERENV','ACTION'),k_nill)
      || k_lf || '- CLIENT_INFO='            || nvl(sys_context('USERENV','CLIENT_INFO'),k_nill)
      || k_lf || '- CLIENT_IDENTIFIER='      || nvl(sys_context('USERENV','CLIENT_IDENTIFIER'),k_nill)
      ;

    l_text := l_text || k_lf || 'NLS_SESSION_PARAMETERS:';
    <<nls_parms>>
    for r_nls in
    (
      select parameter
        ,value
      from nls_session_parameters
      order by parameter
    )
    loop
      l_text := l_text || k_lf || '- ' || r_nls.parameter || '=' || nvl(r_nls.value,k_nill);
    end loop nls_parms;

    if owa.num_cgi_vars is not null
    then
      -- PL/SQL gateway connection (WEB client)
      begin
        l_text := l_text
          || k_lf || 'CGI_ENV:'
          || k_lf || '- REMOTE_ADDR='          || owa_util.get_cgi_env ('REMOTE_ADDR')
          || k_lf || '- PLSQL_GATEWAY='        || owa_util.get_cgi_env ('PLSQL_GATEWAY')
          || k_lf || '- GATEWAY_IVERSION='     || owa_util.get_cgi_env ('GATEWAY_IVERSION')
          || k_lf || '- SERVER_SOFTWARE='      || owa_util.get_cgi_env ('SERVER_SOFTWARE')
          || k_lf || '- GATEWAY_INTERFACE='    || owa_util.get_cgi_env ('GATEWAY_INTERFACE')
          || k_lf || '- SERVER_PORT='          || owa_util.get_cgi_env ('SERVER_PORT')
          || k_lf || '- SERVER_NAME='          || owa_util.get_cgi_env ('SERVER_NAME')
          || k_lf || '- REQUEST_METHOD='       || owa_util.get_cgi_env ('REQUEST_METHOD')
          || k_lf || '- PATH_INFO='            || owa_util.get_cgi_env ('PATH_INFO')
          || k_lf || '- SCRIPT_NAME='          || owa_util.get_cgi_env ('SCRIPT_NAME')
          || k_lf || '- X-FORWARDED-FOR='      || owa_util.get_cgi_env ('X-FORWARDED-FOR')
          || k_lf || '- SERVER_PROTOCOL='      || owa_util.get_cgi_env ('SERVER_PROTOCOL')
          || k_lf || '- REQUEST_PROTOCOL='     || owa_util.get_cgi_env ('REQUEST_PROTOCOL')
          || k_lf || '- REMOTE_USER='          || owa_util.get_cgi_env ('REMOTE_USER')
          || k_lf || '- HTTP_CONTENT_LENGTH='  || owa_util.get_cgi_env ('HTTP_CONTENT_LENGTH')
          || k_lf || '- HTTP_CONTENT_TYPE='    || owa_util.get_cgi_env ('HTTP_CONTENT_TYPE')
          || k_lf || '- HTTP_USER_AGENT='      || owa_util.get_cgi_env ('HTTP_USER_AGENT')
          || k_lf || '- HTTP_HOST='            || owa_util.get_cgi_env ('HTTP_HOST')
          || k_lf || '- HTTP_ACCEPT='          || owa_util.get_cgi_env ('HTTP_ACCEPT')
          || k_lf || '- HTTP_ACCEPT_ENCODING=' || owa_util.get_cgi_env ('HTTP_ACCEPT_ENCODING')
          || k_lf || '- HTTP_ACCEPT_LANGUAGE=' || owa_util.get_cgi_env ('HTTP_ACCEPT_LANGUAGE')
          || k_lf || '- HTTP_REFERER='         || owa_util.get_cgi_env ('HTTP_REFERER')
          || k_lf || '- WEB_AUTHENT_PREFIX='   || owa_util.get_cgi_env ('WEB_AUTHENT_PREFIX')
          || k_lf || '- DAD_NAME='             || owa_util.get_cgi_env ('DAD_NAME')
          || k_lf || '- DOC_ACCESS_PATH='      || owa_util.get_cgi_env ('DOC_ACCESS_PATH')
          || k_lf || '- DOCUMENT_TABLE='       || owa_util.get_cgi_env ('DOCUMENT_TABLE')
          || k_lf || '- PATH_ALIAS='           || owa_util.get_cgi_env ('PATH_ALIAS')
          || k_lf || '- REQUEST_CHARSET='      || owa_util.get_cgi_env ('REQUEST_CHARSET')
          || k_lf || '- REQUEST_IANA_CHARSET=' || owa_util.get_cgi_env ('REQUEST_IANA_CHARSET')
          || k_lf || '- SCRIPT_PREFIX='        || owa_util.get_cgi_env ('SCRIPT_PREFIX')
          || k_lf || '- HTTP_COOKIE='          || owa_util.get_cgi_env ('HTTP_COOKIE')
          ;
      exception
        when others
        then
          l_text := l_text || k_lf || '*E: Error while retrieving CGI_ENV: ' || sqlerrm();
      end;
    else
      l_text := l_text || k_lf || 'CGI_ENV: No PL/SQL gateway connection data available.';
    end if;

    if sys_context('USERENV','SESSION_USER') = 'APEX_PUBLIC_USER'
    then
      -- APEX substitution variables
      begin
        l_text := l_text
          || k_lf || 'APEX-valiables:'
          || lf_get_apex_values('APEX$ROW_NUM')
          || lf_get_apex_values('APEX$ROW_SELECTOR')
          || lf_get_apex_values('APEX$ROW_STATUS')
          || lf_get_apex_values('APP_ID')
          || lf_get_apex_values('APP_ALIAS')
          || lf_get_apex_values('APP_AJAX_X01')
          || lf_get_apex_values('APP_AJAX_X02')
          || lf_get_apex_values('APP_AJAX_X03')
          || lf_get_apex_values('APP_AJAX_X04')
          || lf_get_apex_values('APP_AJAX_X05')
          || lf_get_apex_values('APP_AJAX_X06')
          || lf_get_apex_values('APP_AJAX_X07')
          || lf_get_apex_values('APP_AJAX_X08')
          || lf_get_apex_values('APP_AJAX_X09')
          || lf_get_apex_values('APP_AJAX_X10')
          || lf_get_apex_values('APP_DATE_TIME_FORMAT')
          || lf_get_apex_values('APP_IMAGES')
          || lf_get_apex_values('APP_NLS_DATE_FORMAT')
          || lf_get_apex_values('APP_NLS_TIMESTAMP_FORMAT')
          || lf_get_apex_values('APP_NLS_TIMESTAMP_TZ_FORMAT')
          || lf_get_apex_values('APP_PAGE_ALIAS')
          || lf_get_apex_values('APP_PAGE_ID')
          || lf_get_apex_values('APP_REQUEST_DATA_HASH')
          || lf_get_apex_values('APP_SESSION')
          || lf_get_apex_values('APP_SESSION_VISIBLE')
          || lf_get_apex_values('APP_TITLE')
          || lf_get_apex_values('APP_UNIQUE_PAGE_ID')
          || lf_get_apex_values('APP_USER')
          || lf_get_apex_values('BROWSER_LANGUAGE')
          || lf_get_apex_values('CURRENT_PARENT_TAB_TEXT')
          || lf_get_apex_values('DEBUG')
          || lf_get_apex_values('HOME_LINK')
          || lf_get_apex_values('IMAGE_PREFIX')
          || lf_get_apex_values('JET_BASE_DIRECTORY')
          || lf_get_apex_values('JET_CSS_DIRECTORY')
          || lf_get_apex_values('JET_JS_DIRECTORY')
          || lf_get_apex_values('LOGIN_URL')
          || lf_get_apex_values('LOGOUT_URL')
          || lf_get_apex_values('PRINTER_FRIENDLY')
          || lf_get_apex_values('PROXY_SERVER')
          || lf_get_apex_values('PUBLIC_URL_PREFIX')
          || lf_get_apex_values('REQUEST')
          || lf_get_apex_values('SCHEMA OWNER')
          || lf_get_apex_values('SQLERRM')
          || lf_get_apex_values('SYSDATE_YYYYMMDD')
          || lf_get_apex_values('THEME_DB_IMAGES')
          || lf_get_apex_values('THEME_IMAGES')
          || lf_get_apex_values('WORKSPACE_IMAGES')
          || lf_get_apex_values('WORKSPACE_ID')
          ;
      exception
        when others
        then
          l_text := l_text || k_lf || '*E: Error while retrieving APEX info: ' || sqlerrm();
      end;
    else
      l_text := l_text || k_lf || 'APEX-valiables: No APEX data available.';
    end if;

    log_msg
      (pi_msg     => l_text
      ,pi_type    => fk_logging
      ,pi_level   => fk_normal
      ,pi_scope   => fk_developer
      ,pi_log_opt => 0
      ,pi_tags    => 'LOG_CONNECTION'
      );
  end log_connection;

-- hmo?  -- ---------------------------------------------------------------------------------------------
-- hmo?  -- Procedure to set a log filter
-- hmo?  procedure set_filter
-- hmo?    (pi_field     in varchar2 := hmx_log_ctx_api.c_min_log_lvl
-- hmo?    ,pi_condition in varchar2
-- hmo?    ,pi_log_this  in boolean  := false
-- hmo?    )
-- hmo?  as
-- hmo?  begin
-- hmo?    if nvl(pi_field,hmx_log_ctx_api.c_min_log_lvl) = hmx_log_ctx_api.c_min_log_lvl
-- hmo?    then
-- hmo?      s_minimum_log_level := coalesce
-- hmo?                                  (hmx_utl.to_num_val(pi_condition)
-- hmo?                                  ,nvl(hmx_utl.to_num_val(bf_get_cfg('MINIMUM_hmx_log_LEVEL')),fk_normal)
-- hmo?                                  );
-- hmo?      --hmx_log_ctx_api.set_minimum_log_level
-- hmo?      --  (pi_value     => pi_condition
-- hmo?      --  ,pi_log_this  => pi_log_this
-- hmo?      --  );
-- hmo?    end if;
-- hmo?    -- TODO? HMO 2023-10-19 Extend with other filters?
-- hmo?  end set_filter;

-- -------------------------------------------------------------------------------------------------
-- package constructor
begin

  bp_init_package;

end hmx_log;
/
prompt *I: ScriptEOF hmx_log_pkb.sql
