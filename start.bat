@echo off
chcp 65001 >nul
echo =========================================
echo    DAVOS - Server + Client Launcher
echo =========================================
echo.

:: Verifica se Node.js está instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Node.js nao encontrado! Instale o Node.js primeiro.
    pause
    exit /b 1
)

echo [OK] Node.js encontrado

:: =========================================
:: Verifica/Instala dependencias do SERVER
:: =========================================
echo.
echo [SERVER] Verificando dependencias...

if not exist "server\node_modules" (
    echo [SERVER] node_modules nao encontrado. Instalando dependencias...
    cd server
    call npm install
    cd ..
    echo [SERVER] Dependencias instaladas!
) else (
    echo [SERVER] Dependencias ja instaladas.
)

:: =========================================
:: Inicia o SERVER em uma nova janela
:: =========================================
echo.
echo [SERVER] Iniciando servidor...
start "DAVOS SERVER" cmd /k "cd server && echo [SERVER] Iniciando... && node src/index.js"

:: Aguarda o server iniciar
ping -n 3 127.0.0.1 >nul

:: =========================================
:: Inicia o CLIENT (servidor HTTP estático)
:: =========================================
echo.
echo [CLIENT] Iniciando servidor HTTP para o client...
echo [CLIENT] Acesse: http://localhost:8080

start "DAVOS CLIENT" cmd /k "echo [CLIENT] Servidor HTTP na porta 8080 && echo [CLIENT] Acesse: http://localhost:8080 && npx http-server client -p 8080 -o --cors"

echo.
echo =========================================
echo    Ambos os servidores foram iniciados!
echo =========================================
echo.
echo [INFO] Janelas abertas:
echo   - DAVOS SERVER: Backend WebSocket
echo   - DAVOS CLIENT: Frontend HTTP (porta 8080)
echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
