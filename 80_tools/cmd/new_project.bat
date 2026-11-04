@echo off
rem Initiate a new project
rem HMX 2026-10-11 09:25:12
if "%~1"=="/?" hlp %0
setlocal
set "v_prjdir=H:\20_projects"
set rc=
echo.
echo *I: Create a new standard project folder in %v_prjdir%:
echo.
set /p "subject=Enter the name for the new work folder: "
echo.
if "%subject%" equ "" echo *I: No name entered: Quit. & set "rc=2" & goto :EndOfBat
rem Project Code = YMddx
rem Set prjidx = full path to the project index file
set "prjidx=%v_prjdir%\project_index.tsv"
call get_hmxt_project_code.cmd "%prjidx%" prjcode
rem replace spaces by underscores
set "foldername=%prjcode%_%subject: =_%"
rem set "foldername=%prjcode%_%subject%"
if not exist "%v_prjdir%\%foldername%" goto :createfolder
:else_found
	echo.
	echo *W: Folder %v_prjdir%\%foldername% already exists. Quit.
	set "rc=1"
	goto :EndOfBat
:createfolder
	pushd %v_prjdir%
	xcopy /E /I %HMXT_LOCAL%\doc\templates\project_folder %foldername%
	pushd %foldername%
	tree
	echo Folder  : %cd% > "!scraps_%foldername%.txt"
	echo Project : %foldername% >> "!scraps_%foldername%.txt"
	echo Title   : %subject% >> "!scraps_%foldername%.txt"
	echo Date    : %date% %time% >> "!scraps_%foldername%.txt"
	echo Git repo: git@github.com:HermanMol/%foldername%.git >> "!scraps_%foldername%.txt"
	copy "!scraps_%foldername%.txt" /A + H:\80_programs\hmxt_local\doc\hmxt_hints.txt /A "!scraps_%foldername%.txt" /B
	popd
	set "rc=0"
	popd
	call get_timestamp now
	echo %foldername%	%v_prjdir%	%now%>> "%prjidx%"
	echo *I: New work folder created %v_prjdir%\%foldername%
:EndOfBat
rem wait a while before automatically closing
echo.
if %rc% lss 2 echo *I: About to open folder %v_prjdir%\%foldername% ...
ping -n 5 localhost >nul
if %rc% lss 2 start %v_prjdir%\%foldername%
endlocal
rem pause
exit /b
rem +....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....0
:StartHelp
|
| [30;102m New Project [0m
` new_project
` =========== 
|
| Purpose: Create a new Project Work folder.
|
| Syntax: new_project
|
| Parameters: none (prompts)
|
` !! this line will not be shown in the help !!
| Actions that will be performed:
|  a) Prompts for a project name
|  b) Gets the next unique project code based on the current date and a sequence character.
|  c) Creates the new Project Work subfolder in the Projects folder
|  d) Opens Explorer in the new created project work folder
|
`| Note: The unique project code is registered in file
`|       "H:\20_projects\project_index.tsv"
`|
:EndHelp