@echo off
REM Остановить сервис NoMachine
"%PROGRAMFILES%\NoMachine\bin\nxserver" --stop

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
"%PROGRAMFILES%\NoMachine\bin\nxserver" --start

REM Проверка успешности запуска сервиса
if %ERRORLEVEL% neq 0 (
    echo Не удалось запустить сервис NoMachine
    exit /b %ERRORLEVEL%
)

echo Операция успешно завершена
exit /b 0
ChatGPT
