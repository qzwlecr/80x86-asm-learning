@echo off
cls
echo This Script is used to make MASM compiling ,linking and cleaning automate
echo Created by qzwlecr(Lichen Zhang)
echo Usage: make [option] (asm name(without .asm))
echo option: run, clean
echo Example: make run hello
echo          make clean

if "%1"=="" goto end
if "%1"=="clean" goto clean
if "%1"=="run" goto run
goto end

:run
cls
if not exist %2.asm goto notFound
masm %2.asm
if not errorlevel 1 link %2.obj
%2
goto end

:clean
cls
del *.exe
del *.obj
del *.tr
echo Clean!(=w=)
goto end

:notFound

echo File Not Found!(QAQ)

:end
