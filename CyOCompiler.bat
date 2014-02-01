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
::pause > null
:: Iniciamos el trabajo
c:\apps\node\coffee -o ./js -cbw ./coffee

:: Desmontamos la unidad virtual
popd
:: Esperamos para ver si hay algun error en la ventana
::