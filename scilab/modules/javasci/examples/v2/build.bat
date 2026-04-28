@echo off

rem Path to Scilab data
set SCI=%~dp0..\..\..\..
rem Java API
set CLASSPATH=%SCI%\modules\javasci\jar\org.scilab.modules.javasci.jar;%SCI%\modules\types\jar\org.scilab.modules.types.jar

set PREV_PATH=%PATH%
set PATH=%SCI%\bin;%PATH%

echo.
echo Example1
javac -cp %CLASSPATH% %~dp0Example1.java
java -cp %CLASSPATH%;%~dp0 Example1

echo.
echo Example2
javac -cp %CLASSPATH% %~dp0Example2.java
java -cp %CLASSPATH%;%~dp0 Example2
set PATH=%PREV_PATH%
