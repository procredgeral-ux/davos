@echo off
chcp 65001 >nul
echo =========================================
echo    DAVOS - Server Launcher
echo =========================================
echo.

:: Verifica se Node.js esta instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Node.js nao encontrado! Instale o Node.js primeiro.
    pause
    exit /b 1
)

echo [OK] Node.js encontrado

:: Verifica/Instala dependencias
echo.
echo [SERVER] Verificando dependencias...

if not exist "node_modules" (
    echo [SERVER] node_modules nao encontrado. Instalando...
    npm install
    echo [SERVER] Dependencias instaladas!
) else (
    echo [SERVER] Dependencias ja instaladas.
)

:: Inicia o servidor
echo.
echo [SERVER] Iniciando servidor...
node src/index.js

pause
