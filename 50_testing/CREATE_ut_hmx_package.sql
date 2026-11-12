prompt *I: ScriptBOF CREATE_ut_hmx_package.sql
-- Create a new utPLSQL test package for an existing package
-- HMO, 2026-11-12 16:33:49

-- Arguments can be specified on the command line or are prompted
--   1. Package name...: The name of the package to generate the unit test package for.
--                       Required. When not specified this script crashes.
--   2. Suite..........: The unit test suite description.
--                       Required, the utPLSQL default is the package name.
--   3. Suite path.....: The unit test suite path description.
--                       Optional, if specified it should resemble Java packages.
--   4. Context........: The unit test context description.
--                       Optional, default is none.
--   5. ut-pkg prefix..: The prefix for the unit test package name.
--                       If no trailing underscore, it will be added.
--                       Required because without it the source package would be overwritten.
--                       When not specified, the default is "ut_".
--   6. ut-pkg suffix..: The suffix for the unit test package name.
--                       If no leading underscore, it will be added.
--                       Optional, default is none.
-- The full name of the unit test package will be: prefix+package+suffix.

-- =================================================================================================
-- Start with a clean fresh session
exec dbms_session.reset_package;

-- @CREATE_ut_hmx_package arg1 arg2 arg3 agr4 arg5 arg6
-- -------------------------------------------------------------------------------------------------
-- Manage required input values
argument 1 prompt "#1. Package name...: "
argument 2 prompt "#2. Suite..........: "
argument 3 prompt "#3. Suite path.....: "
argument 4 prompt "#4. Context........: "
argument 5 prompt "#5. ut-pkg prefix..: "
argument 6 prompt "#6. ut-pkg suffix..: "

var v_pkg_name     varchar2(128)
var v_suite        varchar2(128)
var v_suitepath    varchar2(128)
var v_context      varchar2(128)
var v_pkg_pfx      varchar2(10)
var v_pkg_sfx      varchar2(10)
var v_ut_pkg_name  varchar2(128)

begin
    :v_pkg_name    := substr(trim('&1.'),1,128);
    :v_suite       := substr(trim('&2.'),1,128);
    :v_suitepath   := substr(trim('&3.'),1,128);
    :v_context     := substr(trim('&4.'),1,128);
    :v_pkg_pfx     := coalesce(nullif(substr(trim(both '_' from trim('&5.') ),1,9) || '_','_'),'ut_');
    :v_pkg_sfx     := nullif('_' || substr(trim(both '_' from trim('&6.') ),1,9),'_');
    :v_ut_pkg_name := lower(:v_pkg_pfx || :v_pkg_name || :v_pkg_sfx);
end;
/
tosub v_pkg_name=:v_pkg_name
tosub v_suite=:v_suite
tosub v_suitepath=:v_suitepath
tosub v_context=:v_context
tosub v_pkg_pfx=:v_pkg_pfx
tosub v_pkg_sfx=:v_pkg_sfx
tosub v_ut_pkg_name=:v_ut_pkg_name
-- -------------------------------------------------------------------------------------------------
-- Open the spool file for the ut package spec

@hmx_spoolddlstart &v_ut_pkg_name._pks.sql
begin

    hmx_utplsql_utl.set_tags('utPLSQL_' || regexp_substr(ut.version,'(v([0-9]+\.){3})',1,1,'i',1));
    hmx_utplsql_utl.set_ut_package_prefix(pi_ut_package_prefix => :v_pkg_pfx);
    hmx_utplsql_utl.set_ut_package_suffix(pi_ut_package_suffix => :v_pkg_sfx);

    hmx_utplsql_utl.generate_test_package_spec
        (pi_package_name => upper(:v_pkg_name)
        ,pi_suite        => :v_suite
        ,pi_suitepath    => :v_suitepath
        ,pi_context      => :v_context
        );

end;
/
@hmx_spoolfinish

@hmx_spoolddlstart &v_ut_pkg_name._pkb.sql
begin

    hmx_utplsql_utl.set_tags('utPLSQL_' || regexp_substr(ut.version,'(v([0-9]+\.){3})',1,1,'i',1));
    hmx_utplsql_utl.set_ut_package_prefix(pi_ut_package_prefix => 'ut_');
    hmx_utplsql_utl.set_ut_package_suffix(pi_ut_package_suffix => null);

    hmx_utplsql_utl.generate_test_package_body
        (pi_package_name => upper(:v_pkg_name)
        ,pi_suite        => :v_suite
        ,pi_suitepath    => :v_suitepath
        ,pi_context      => :v_context
        );

end;
/
@hmx_spoolfinish

-- -------------------------------------------------------------------------------------------------
-- Compile the generated spec and body

@hmx_spoolstart CREATE_ut_hmx_package.sql
prompt *I: Compile new version utPLSQL test package &v_ut_pkg_name. for &v_pkg_name.
prompt *I: Specification ...
@@&v_ut_pkg_name._pks.sql
prompt *I: Body ...
@@&v_ut_pkg_name._pkb.sql

@hmx_recompile_invalid_all
@hmx_report_invalid_all
prompt *I: Done.
@hmx_spoolfinish

-- -------------------------------------------------------------------------------------------------
-- Clean-up and finish

prompt *I: Summary:
prompt - Package name..... : &v_pkg_name.
prompt - Suite............ : &v_suite.
prompt - Suite path....... : &v_suitepath.
prompt - Context     ..... : &v_context.
prompt - UT package prefix : &v_pkg_pfx.
prompt - UT package suffix : &v_pkg_sfx.
prompt - UT package name.. : &v_ut_pkg_name.

undefine 1
undefine 2
undefine 3
undefine 4
undefine 5
undefine 6
undefine v_pkg_name
undefine v_suite
undefine v_suitepath
undefine v_context
undefine v_pkg_pfx
undefine v_pkg_sfx
undefine v_ut_pkg_name

prompt *I: ScriptEOF CREATE_ut_hmx_package.sql
