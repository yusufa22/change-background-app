@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:---------------------------------
schtasks.exe /delete /tn lockscreenchange /F >nul 2>&1
schtasks.exe /delete /tn desktopbackgroundchange /F >nul 2>&1
for /f "delims=" %%a in ('powershell -command "echo $pwd"') do Set "$Value=%%a"
for /f "delims=" %%a in ('powershell -command "[xml] $test = get-content .\win_scheduler_templates\lock_screen_change_template; $test.Task.Actions.Exec.Arguments"') do Set "$current=%%a"
set folder=%$current%
if "%$current%"=="" set folder=%$Value%\backgrounds
:question
set /p answer=The Picture Folder is currently set to %folder%. Do you want to change it? [Y/N]: 
set number=1
:decision
if "%answer%"=="y" GOTO yes
if "%answer%"=="Y" GOTO yes
if "%answer%"=="n" GOTO finish
if "%answer%"=="N" GOTO finish
if %number%==3 GOTO failure
set /A counter=number-3
set /A counter2=-counter
set /A number=number+1
if %counter2%==1 GOTO last
set /p answer=Invalid Input. you have %counter2% more chances. please try again:  
goto return
:last
set /p answer=Invalid Input. you have %counter2% more chance. please try again:  
:return
if %number%==3 GOTO failure
GOTO decision
:failure 
echo You have given an invalid input too many times. The program will now exit.
pause
exit
:yes
set /p folder= Please enter the Path to your preferred Picture Folder: 
::no label being executed after yes label
:finish
powershell.exe -ExecutionPolicy Bypass -file ".\main.ps1" "%folder%"
schtasks.exe /Create /XML .\win_scheduler_templates\lock_screen_change_template /tn lockscreenchange
schtasks.exe /Create /XML .\win_scheduler_templates\desktop_background_change_template /tn desktopbackgroundchange 
pause