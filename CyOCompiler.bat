@echo off

::-------------------------------
:: en vez de:
:: pushd \\cymautocert\osaapp\dmndev\
:: usare
:: pushd "%~dp0"
:: %~dp0 expands to the current (d)rive/(p)ath/(0)batchfilename
::-------------------------------
cls


:: Primero ponemos un buen nombre a la ventana
title Compilador de coffeeScript
:: Creamos una unidad temporal
pushd "%~dp0"
set var = c:\apps\node

:menu
color 0C
cls

echo ======= PRINCIPAL ===========
echo -----------------------------
echo 1. Information
echo 2. Watch and compile coffee
echo 3. Uglify Files
echo 
echo -----------------------------
echo ==== PRESS 'Q' TO QUIT =====

SET M =
SET /P M=Select a number:
echo "%M%"
if %M%  == 1 goto Information
if %M%  == 2 goto watchAndCompile
if %M%  == 3 goto Uglify
if %M%  == Q goto quit
if %M%  == q goto quit

cls
echo -                           -
echo ==== INVALID INPUT ==========
echo -----------------------------
pause > null
goto menu

:watchAndCompile
cls
:: Iniciamos el trabajo
c:\apps\node\coffee -o ./js -cbw ./coffee
goto menu

:Uglify
cls
c:\apps\node\uglifyjs -o js/base.min.js js/base.js
pause > null
goto menu

:quit
pause > null
:: Desmontamos la unidad virtual
popd