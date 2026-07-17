echo off
set LOCALHOST=%COMPUTERNAME%
set KILL_CMD="C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v261\fluent/ntbin/win64/winkill.exe"

start "tell.exe" /B "C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v261\fluent\ntbin\win64\tell.exe" SimonAsusLaptop 62635 CLEANUP_EXITING
timeout /t 1
"C:\PROGRA~1\ANSYSI~1\ANSYSS~1\v261\fluent\ntbin\win64\kill.exe" tell.exe
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 27328) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 26516) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 25564) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 27848) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 36744) 
if /i "%LOCALHOST%"=="SimonAsusLaptop" (%KILL_CMD% 34740)
del "C:\Users\Simon\Projects\MEng Electronics\Development of a Resistojet Thruster\2) Simulations\CFD\cleanup-fluent-SimonAsusLaptop-36744.bat"
