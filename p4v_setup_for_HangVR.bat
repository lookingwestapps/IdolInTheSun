@ECHO OFF

where p4  >nul 2>&1



if %ERRORLEVEL% NEQ 0 (

  echo To run this script, you will need to first download and install the p4 commandline client.  You can download it from: http://www.perforce.com/product/components/perforce-commandline-client

  goto FinishError

)



p4 -Cauto -p ssl:HangVR.abrancard.helix.perforce.com:1667 trust



if %ERRORLEVEL% NEQ 0 (

  echo Trust not extended, exited without setting up a local workspace.

  goto FinishError

)



mkdir HangVR  >nul 2>&1

cd HangVR

for /f %%i in ('cd') do set CURRENTDIR=%%i

for /f %%i in ('hostname') do set HNAME=%%i

p4 -Cauto -p ssl:HangVR.abrancard.helix.perforce.com:1667 -u abrancard login



if %ERRORLEVEL% NEQ 0 (

  echo Login failed, exited without setting up a local workspace.

  cd ..

  goto FinishError

)



p4 -Cauto -p ssl:HangVR.abrancard.helix.perforce.com:1667 -u abrancard client -o -S //HangVR/main abrancard_HangVR_%HNAME% | p4 -Cauto -p ssl:HangVR.abrancard.helix.perforce.com:1667 -u abrancard client -i

for /f "tokens=3" %%r in ('p4 -Cauto -p ssl:HangVR.abrancard.helix.perforce.com:1667 -u abrancard -c abrancard_HangVR_%HNAME% info ^| findstr /c:"Client root:"') do set CROOT=%%r



echo.

if /I %CROOT% == %CURRENTDIR% (

  echo Downloading files...this may take awhile

  p4 -Cauto -p ssl:HangVR.abrancard.helix.perforce.com:1667 -u abrancard -c abrancard_HangVR_%HNAME% sync

  echo Finished downloading, get to work!

  echo.

) else (

  echo It appears you have already run this setup script in:

  echo %CROOT%

  echo.

  echo You can edit your workspace in P4V if you want to move it to:

  echo %CURRENTDIR%

  cd ..

  echo.

)

echo To connect to your project with p4v, use the following credentials:

echo Server:    ssl:HangVR.abrancard.helix.perforce.com:1667

echo User:      abrancard

echo Workspace: abrancard_HangVR_%HNAME%

echo.

echo You will also need the password that you use to connect to Helix Cloud

cd ..

goto Finish

/r/n
:Finish

  pause

goto:eof

/r/n
:FinishError

  pause

  exit /B %ERRORLEVEL%

goto:eof

