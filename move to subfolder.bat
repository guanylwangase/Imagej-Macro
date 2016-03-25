@echo off
for %%a in (*.*) do for /f "tokens=7 delims=_" %%b in ("%%a") do (
if not exist %%b\ md %%b\
move "%%a" %%b\
)