@echo off

REM Определение переменной пути к NoMachine по умолчанию
set NOMACHINE_PATH=C:\Program Files\NoMachine

REM Проверка наличия NoMachine в Program Files (x86)
if exist "C:\Program Files (x86)\NoMachine\bin\nxserver.exe" (
    set NOMACHINE_PATH=C:\Program Files (x86)\NoMachine
) else if exist "C:\Program Files\NoMachine\bin\nxserver.exe" (
    REM NoMachine уже установлен в Program Files, путь оставляем без изменений
    set NOMACHINE_PATH=C:\Program Files\NoMachine
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

REM Подождать несколько секунд (60) перед запуском сервиса
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
