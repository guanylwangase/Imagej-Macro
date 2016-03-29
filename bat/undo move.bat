@echo off
for /r . %%a in (*.tif) do if exist "%%a" move /y "%%a" .