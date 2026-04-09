@echo off
setlocal enabledelayedexpansion
:: ─────────────────────────────────────────
::  Encantos de Festas — Git Auto Deploy
::  Coloque em C:\encantos\ e execute
::  quando Claude enviar uma atualização!
:: ─────────────────────────────────────────

set PASTA=C:\encantos
set ARQUIVO=encantos_site.html
set DOWNLOADS=%USERPROFILE%\Downloads

title Encantos de Festas - Deploy GitHub

cls
echo.
echo  ====================================
echo   Encantos de Festas - Auto Deploy
echo  ====================================
echo.

:: 1. Verifica se existe novo arquivo nos Downloads
echo  [1/5] Verificando novo arquivo nos Downloads...
set FOUND=0
for /f "delims=" %%F in ('dir /b /o-d "%DOWNLOADS%\encantos_site*.html" 2^>nul') do (
    if !FOUND!==0 (
        set NOVO=%%F
        set FOUND=1
    )
)

if !FOUND!==1 (
    echo  [OK] Novo arquivo encontrado: !NOVO!
    echo.

    :: 2. Copia para a pasta substituindo o antigo
    echo  [2/5] Atualizando arquivos...
    del "%PASTA%\%ARQUIVO%" >nul 2>&1
    copy "%DOWNLOADS%\!NOVO!" "%PASTA%\%ARQUIVO%" >nul
    del "%DOWNLOADS%\!NOVO!" >nul 2>&1

    :: 3. Cria o index.html
    cp "%PASTA%\%ARQUIVO%" "%PASTA%\index.html" >nul 2>&1
    copy /Y "%PASTA%\%ARQUIVO%" "%PASTA%\index.html" >nul 2>&1
    echo  [OK] Arquivos atualizados!
    echo.
) else (
    echo  [INFO] Nenhum arquivo novo nos Downloads.
    echo  [INFO] Fazendo deploy da versao atual...
    echo.
)

:: 4. Git add + commit + push
echo  [3/5] Adicionando arquivos ao Git...
cd /d "%PASTA%"
git add . >nul 2>&1
echo  [OK] Feito!
echo.

echo  [4/5] Criando commit...
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set DT=%%I
set TIMESTAMP=!DT:~6,2!/!DT:~4,2!/!DT:~0,4! !DT:~8,2!:!DT:~10,2!
git commit -m "Atualizacao automatica - !TIMESTAMP!" >nul 2>&1
echo  [OK] Commit criado!
echo.

echo  [5/5] Enviando para o GitHub...
git push origin main
echo.

if %errorlevel%==0 (
    echo  ====================================
    echo   SUCESSO! Site atualizado!
    echo.
    echo   Acesse em 1-2 minutos:
    echo   https://ribeirodeoliveirag559-collab
    echo   .github.io/Encanto-de-Festa/
    echo  ====================================
) else (
    echo  ====================================
    echo   ERRO ao enviar para o GitHub!
    echo   Verifique sua conexao e tente novamente.
    echo  ====================================
)

echo.
pause
