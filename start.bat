@echo off
chcp 65001 >nul
echo =========================================
echo    DAVOS - Development Server Launcher
echo =========================================
echo.

:: Verifica se Node.js esta instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Node.js nao encontrado! Instale o Node.js primeiro.
    pause
    exit /b 1
)

echo [OK] Node.js detectado
echo.

:: Instala dependencias na raiz (para Railway deploy)
echo [INFO] Verificando dependencias do projeto...
if not exist "node_modules" (
    echo [INFO] Instalando dependencias...
    npm install
    echo [OK] Dependencias instaladas!
) else (
    echo [OK] Dependencias ja instaladas.
)

:: Verifica/Instala dependencias do server
echo.
echo [SERVER] Verificando dependencias do servidor...
cd server
if not exist "node_modules" (
    echo [SERVER] Instalando dependencias...
    npm install
    echo [OK] Dependencias do servidor instaladas!
) else (
    echo [OK] Dependencias do servidor OK.
)
cd ..

echo.
echo =========================================
echo    Iniciando Servidores
echo =========================================
echo.

:: Inicia o servidor de jogo (WebSocket na porta 443)
echo [SERVER] Iniciando Game Server (WebSocket:443)...
start "DAVOS - Game Server" cmd /k "cd server && npm start"

:: Aguarda o servidor iniciar
timeout /t 3 /nobreak >nul

:: Inicia o servidor web (HTTP na porta 8080)
echo [WEB] Iniciando Web Server (HTTP:8080)...
start "DAVOS - Web Server" cmd /k "npx http-server client -p 8080 --cors -o"

echo.
echo =========================================
echo    Servidores Iniciados!
echo =========================================
echo.
echo [INFO] Game Server:   ws://localhost:443
echo [INFO] Web Server:    http://localhost:8080
echo [INFO] Stats:         http://localhost:88/stats
echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
