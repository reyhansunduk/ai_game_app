@echo off
set GRADLE_USER_HOME=C:\gradle-home
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
cd /d "%~dp0"
C:\flutter\bin\flutter.bat run -d emulator-5554
