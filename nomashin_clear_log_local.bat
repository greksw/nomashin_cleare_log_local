@echo off

REM Определение переменной пути к NoMachine
set NOMACHINE_PATH=%PROGRAMFILES%\NoMachine

if exist "%PROGRAMFILES(X86)%\NoMachine\bin\nxserver.exe" (
    set NOMACHINE_PATH=%PROGRAMFILES(X86)%\NoMachine
) else if exist "%PROGRAMFILES%\NoMachine\bin\nxserver.exe" (
    set NOMACHINE_PATH=%PROGRAMFILES%\NoMachine
) else (
    echo NoMachine не найден ни в Program Files, ни в Program Files (x86)
    exit /b 1
)

REM Остановить сервис NoMachine
"%NOMACHINE_PATH%\bin\nxserver.exe" --stop

REM Проверка успешности остановки сервиса
if %ERRORLEVEL% neq 0 (
    echo Не удалось остановить сервис NoMachine
    exit /b %ERRORLEVEL%
)

REM Подождать несколько секунд для завершения остановки служб
timeout /t 10 /nobreak

REM Очистить папку C:\ProgramData\NoMachine\var\log\node
del /q "C:\ProgramData\NoMachine\var\log\node\*"

REM Проверка успешности удаления файлов
if %ERRORLEVEL% neq 0 (
    echo Не удалось очистить папку C:\ProgramData\NoMachine\var\log\node
    exit /b %ERRORLEVEL%
)

REM Подождать несколько секунд(60) перед запуском сервиса
timeout /t 60 /nobreak

REM Запустить сервис NoMachine
"%NOMACHINE_PATH%\bin\nxserver.exe" --start

REM Проверка успешности запуска сервиса
if %ERRORLEVEL% neq 0 (
    echo Не удалось запустить сервис NoMachine
    exit /b %ERRORLEVEL%
)

echo Операция успешно завершена
exit /b 0
