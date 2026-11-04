rem Example call get_timestamp now
rem Version: hm21@11jul2021
rem Version 2026-10-01 10:35:12 using PowerShell i.s.o. WMIC (which is no longer used)
setlocal
for /f %%I in ('powershell -NoLogo -NoProfile -Command "(Get-Date).ToString(\"yyyyMMdd_HHmmss\")"') do set "_isodate=%%I"
rem echo *D: _isodate = %_isodate%
rem pause
(endlocal & set "%1=%_isodate%")
exit /b
