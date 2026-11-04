@echo off
rem get_hmxt_project_code.cmd
rem Get a unique code as reference for a project.
rem Arguments:
rem - #1 = Full path to the project index file to be searched
rem - #2 = the name of the local variable to receive the generated project code YMddx
rem This command is meant as subroutine.
rem HMXT 2023-07-30 12:13:28
setlocal
rem project Code = YMddx
rem 
rem Upper and lower codes, the first is index=0 should not be used
rem - Y  = Sysdate Year:  2021    = A
rem - M  = Sysdate Month: Januari = A
rem - dd = month day, two digits: 01, 02, ...31
rem - x  = A sequence if more than 1 project on a day
rem - Registered in the file received thru argument #1
if "%~1" equ "" echo *E: Required argument #1 = project_index file full path is empty. & pause & exit /b 1
if "%~2" equ "" echo *E: Required argument #2 = return variable is empty. & pause & exit /b 2
set "tpcidx=%~1"
set "upper_codes=#ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789**************************"
set "lower_codes=#abcdefghijklmnopqrstuvwxyz0123456789**************************"
call get_timestamp.cmd today
rem echo *D: today = %today%
set "year=%today:~0,4%"
rem Trick#1: prefix the numeric month number with a 1 to avoid confusion with hexadecimal or octal constant value if month starts with a zero
set "mnth=1%today:~4,2%"
set "dnum=%today:~6,2%"
set /a "yn=%year% - 2020"
rem Trick#2: subtract 100 (removing the prefixed 1) and make the month number a true numeric value without leading zero.
set /a "mn=%mnth% - 100"
rem
call :get_upper_code yc %yn%
call :get_upper_code mc %mn%
rem echo *D: date-code=%yc%%mc%%dnum%
rem find all lines starting with the YMdd in the project index file
for /F "usebackq eol=# tokens=1* delims== " %%i in (`findstr /B /I /C:"%yc%%mc%%dnum%" "%tpcidx%" ^| wc -l `) do (
	set "fndcnt=%%i"
		)
rem echo *D: fndcnt = %fndcnt%
if "%fndcnt%" equ "" set "fndcnt=0" 
set /a fndcnt=fndcnt + 1
call :get_lower_code lc %fndcnt%
set "retcode=%yc%%mc%%dnum%%lc%"
(endlocal & set "%2=%retcode%")
exit /b
rem ======================== subroutines =====================
rem Get the upper case character at the specified position
:get_upper_code
	setlocal enabledelayedexpansion
	set "rc=!upper_codes:~%2,1!"
	(endlocal & set "%1=%rc%")
exit /b
rem Get the lower case character at the specified position
:get_lower_code
	setlocal enabledelayedexpansion
	set "rc=!lower_codes:~%2,1!"
	(endlocal & set "%1=%rc%")
exit /b
