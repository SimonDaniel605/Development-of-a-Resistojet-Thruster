echo off
set LOCALHOST=%COMPUTERNAME%
set KILL_CMD="C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v261\fluent/ntbin/win64/winkill.exe"

start "tell.exe" /B "C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v261\fluent\ntbin\win64\tell.exe" SimonAsusLaptop 65478 CLEANUP_EXITING
timeout /t 1
"C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v261\fluent\ntbin\win64\kill.exe" tell.exe
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 4572) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 14292) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 23916) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 3812) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 20812) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 25536)
del "C:\Users\Simon\Projects\MEng Electronics\Development of a Resistojet Thruster\2) Simulations\CFD\cleanup-fluent-SimonAsusLaptop-20812.bat"
