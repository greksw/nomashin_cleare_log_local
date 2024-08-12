@echo off

REM Проверка наличия NoMachine в Program Files (x86)
if exist "C:\Program Files (x86)\NoMachine\bin\nxserver.exe" (
    echo NoMachine найден в Program Files (x86)
    set NOMACHINE_PATH=C:\Program Files (x86)\NoMachine
) else (
    echo NoMachine не найден в Program Files (x86)
)

REM Проверка наличия NoMachine в Program Files
if exist "C:\Program Files\NoMachine\bin\nxserver.exe" (
    echo NoMachine найден в Program Files
    set NOMACHINE_PATH=C:\Program Files\NoMachine
) else (
    echo NoMachine не найден в Program Files
)

REM Проверка, установлен ли путь к NoMachine
if not defined NOMACHINE_PATH (
    echo NoMachine не найден ни в одной из проверенных директорий
    exit /b 1
)

echo Путь к NoMachine установлен: %NOMACHINE_PATH%

REM Остановка сервиса NoMachine
echo Попытка остановить сервис NoMachine...
"%NOMACHINE_PATH%\bin\nxserver.exe" --stop

REM Проверка успешности остановки сервиса
if %ERRORLEVEL% neq 0 (
    echo Не удалось остановить сервис NoMachine
    exit /b %ERRORLEVEL%
)

echo Сервис NoMachine успешно остановлен

REM Завершение оставшихся процессов NoMachine
echo Завершение процессов nxplayer.bin и nxrunner.bin...
taskkill /f /im nxplayer.bin
taskkill /f /im nxrunner.bin

REM Проверка успешности завершения процессов
if %ERRORLEVEL% neq 0 (
    echo Не удалось завершить один или несколько процессов NoMachine
    exit /b %ERRORLEVEL%
)

REM Подождать несколько секунд для завершения остановки служб и завершения процессов
timeout /t 10 /nobreak

REM Проверка наличия файлов в папке перед удалением
echo Проверка наличия файлов в папке C:\ProgramData\NoMachine\var\log\node
dir "C:\ProgramData\NoMachine\var\log\node"

REM Очистить папку с логами
echo Очистка папки C:\ProgramData\NoMachine\var\log\node
del /q "C:\ProgramData\NoMachine\var\log\node\*"

REM Проверка успешности удаления файлов
if %ERRORLEVEL% neq 0 (
    echo Не удалось очистить папку C:\ProgramData\NoMachine\var\log\node
    exit /b %ERRORLEVEL%
) else (
    echo Папка C:\ProgramData\NoMachine\var\log\node успешно очищена
)

REM Проверка наличия файлов в папке после удаления
echo Проверка наличия файлов в папке C:\ProgramData\NoMachine\var\log\node после очистки
dir "C:\ProgramData\NoMachine\var\log\node"

REM Подождать несколько секунд перед запуском сервиса
timeout /t 60 /nobreak

REM Запуск сервиса NoMachine
echo Попытка запустить сервис NoMachine...
"%NOMACHINE_PATH%\bin\nxserver.exe" --start

REM Проверка успешности запуска сервиса
if %ERRORLEVEL% neq 0 (
    echo Не удалось запустить сервис NoMachine
    exit /b %ERRORLEVEL%
)

echo Сервис NoMachine успешно запущен
exit /b 0
