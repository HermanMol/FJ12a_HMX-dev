create or replace package body ut_hmx_utl_01 as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Unit Test HMX_UTL

.HMX_OBJECT_NOTES:
    Created manualy, first try at utPLSQL, simple, as proof of concept

.HMX_DEVELOPER_NOTES:
    - See HMX General Developer Notes

.HMX_OBJECT_VERSION: 2026-11-12 08:22:58 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    procedure test_0001
    is
    begin
        prt('*T: executing ut_hmx_utl_01.TEST_001...');
        ut.expect(hmx_utl.f_max_chars
                        (pi_base_chars  => '123456789'
                        ,pi_max         => 5
                        ) 
                ).to_equal('12...');
    end test_0001;

    procedure test_0002
    is
    begin
        prt('*T: executing ut_hmx_utl_01.TEST_002...');
        ut.expect(hmx_utl.f_max_chars
                        (pi_base_chars  => '123456789'
                        ,pi_max         => 9
                        ) 
                ).to_equal('123456789');
    end test_0002;

    procedure test_0003
    is
    begin
        prt('*T: executing ut_hmx_utl_01.TEST_003...');
        ut.expect(hmx_utl.f_max_chars
                        (pi_base_chars  => '123456789'
                        ,pi_add_chars   => 'asdfefg'
                        ,pi_max         => -6
                        ) 
                ).to_equal('...efg');
    end test_0003;

end ut_hmx_utl_01;
/