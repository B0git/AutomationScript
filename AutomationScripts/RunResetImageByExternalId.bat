@echo off

setlocal

if "%TEAMS_HOME%" == "" goto setEnvVars
if "%JAVA_HOME%" == "" goto setEnvVars
if "%JBOSS_HOME%" == "" goto setEnvVars

goto run

:setEnvVars
echo One or more required environment variables are not set.
goto exit

:run

set TEAMS_LIB=%TEAMS_HOME%\jars

set RUNCMD=%JAVA_HOME%\bin\java
set RUNCMD=%RUNCMD% -classpath .\CleanUp.jar;%TEAMS_LIB%\TEAMS-sdk.jar;%TEAMS_LIB%\TEAMS-common.jar;%TEAMS_LIB%\Regexp.jar;%TEAMS_LIB%\commons-io-1.2.jar;%TEAMS_LIB%\log4j.jar;%TEAMS_LIB%\xml4j_2_0_15.jar;%TEAMS_LIB%\commons-logging.jar;%TEAMS_LIB%\commons-beanutils.jar;%TEAMS_LIB%\commons-lang-2.0.jar;%TEAMS_LIB%\jdom.jar;%TEAMS_LIB%\activation.jar;%JBOSS_HOME%\client\jbossall-client.jar
set RUNCMD=%RUNCMD% -DTEAMS_HOME=%TEAMS_HOME%
set RUNCMD=%RUNCMD% com.hrs.hotel.cleanup.ResetImageByExternalID
ECHO %RUNCMD%
ECHO %TEAMS_HOME%
%RUNCMD% %*

:exit
