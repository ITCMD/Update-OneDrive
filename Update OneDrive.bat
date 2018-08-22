@echo off
setlocal EnableDelayedExpansion
color 08
set num=0
:top
set OD=C:\users\%username%\OneDrive
if exist C:\users\Public\OneDrivePath.txt set /p OD=<C:\users\Public\OneDrivePath.txt
if not exist "%OD%\*.*" goto SetOneDrive
if "%~1"=="" goto menu
set tot=1 & set f1=%1
if not "%~2"=="" set tot=2 & set f2=%2
if not "%~3"=="" set tot=3 & set f3=%3
if not "%~4"=="" set tot=4 & set f4=%4
if not "%~5"=="" set tot=5 & set f5=%5
if not "%~6"=="" echo [[91mERROR: Maximum of five files at once.[0m]
:loops
echo [7m[4m====================================================================================================[0m
set /a num+=1
set f=!f%num%!

if not exist %f% goto notexist
echo [92mYou have Selected [4m%f%[0m[92m file[0m
for /f "tokens=*" %%A in ('dir /b %f%') do ( set File=%%A )

for /F "tokens=*" %%I in ("%file%") do (
	set fwen=%%~II
)
for /F "tokens=*" %%I in ("%fwen%") do (
	set fwen=%%~nI
)
for /F "tokens=*" %%I in ("%file%") do (
	set fwe=%%~nI
)
for /F "tokens=*" %%I in ("%file%") do (
	set ext=%%~xI
)
set var=%fwe:~-3%
set whole=%var:~0,1%
set integ=%var:~-1%
echo %var%| find ".">nul
if not %errorlevel%==0 goto notnum
if %integ%==9 goto 9
set /a integ+=1
:back9
set new=%fwe:~0,-3%%whole%.%integ%%ext%
echo %f%|find "%OD%" >nul
if %errorlevel%==0 goto inod
echo [33mNOTICE: This File is Not Currently in OneDrive.[0m
set inod=Y
:inod
for /F "tokens=*" %%I in ("%f%") do (
	set fdd=%%~dI
)
for /F "tokens=*" %%I in ("%f%") do (
	set fpp=%%~pI
)
for /F "tokens=*" %%I in ("%f%") do (
	set f=%%~I
)
echo applying changes . . . 
echo         Copying file to new name and deleting old.
copy "%f%" "%fdd%%fpp%%new%"
del /f /q "%f%"
if not %errorlevel%==0 goto errc
echo         New File name: [37m%fwen:~0,-3%[97m[4m%whole%.%integ%[0m[37m%ext%[0m
echo         File Path: %fdd%%fpp%%new%
if not %errorlevel%==0 echo         [31m [4mWARNING:[0m[31m Level %errorlevel% Error.
if not %num%==%tot% goto loops
echo Updated %TOT% files.
echo [92mSuccess. Update Completed. [0m
if %TOT% GTR 2 echo Updated Files:
if %TOT% GTR 2 echo [107m[30m %1            %2            %3            %4            %5
pause >nul
exit /b

:notnum
set whole=1
set integ=0
set fwe=%fwe% ###
echo [33mNOTICE: File did not have version markers. Added [41.0[0m
goto back9


:9
if %whole%==9 goto starover
set integ=0
set /a whole+=1
goto back9

:starover
echo [33mNOTICE: New version is set to 1.0 since 9.9 was previous.[0m
set whole=1
set integ=0
goto back9

:menu
:setup
if not exist "%OD%\*.*" goto setOneDrive
cls
color 0f
echo [33mNOTICE: No File was selected. Drag and drop onto this file to update.[0m
echo Welcome to the ITCMD OneDrive Updator Menu.
echo [4mPlease Select an option:[0m
echo.
echo 1] Update New File
echo 2] Change OneDrive Root Directory
echo [90m   Press X to close.[0m
choice /c 12x /n
goto men%errorlevel%

:men3
exit

:men1
echo [4mDRAG AND DROP FILE ONTO WINDOW[0m Then Press Enter.           
set /p file=">"
call %0 %file%
exit /b


:men2
echo NOTE: If you use the default OneDrive Folder change nothing.
goto men22

:SetOneDrive
echo [7;31mERROR![0m
echo OneDrive Path Was Not Found!
:men22
echo Please Enter the path to onedrive below:
echo NOTE: you can also drag and drop the OneDrive Folder onto the screen.
echo.
set /p OD=">"
if not exist %OD% goto setOneDrive
echo [92mSuccess.[0m
set VAR=%OD%
echo %VAR%| findstr /i \^" >nul
if %errorlevel%==0 call :DeQuote %OD%
echo %VAR%>"C:\users\Public\OneDrivePath.txt"
goto top




:DeQuote
set var=%1
set var=%var:"=%
exit /b