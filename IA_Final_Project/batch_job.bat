@echo off
setlocal

REM Directory where the Jupyter Notebooks are located
set NOTEBOOK_DIR=Python_Scripts

REM Convert each Jupyter Notebook to a Python script
for %%f in (%NOTEBOOK_DIR%\*.ipynb) do (
    echo Converting %%f to Python script...
    jupyter nbconvert --to script %%f
)
echo Conversion completed.

REM Paths to your Python scripts
set SCRIPT1=Python_Scripts\Air_Script.py
set SCRIPT2=Python_Scripts\Water_Script.py

REM Run Script 1 and wait for it to finish
echo Running Script 1...
python %SCRIPT1%
if %ERRORLEVEL% neq 0 (
    echo Error occurred while running Script 1. Exiting.
    
)
echo Script 1 completed successfully.

REM Run Script 2 and wait for it to finish
echo Running Script 2...
python %SCRIPT2%
if %ERRORLEVEL% neq 0 (
    echo Error occurred while running Script 2. Exiting.
    
)
echo Script 2 completed successfully.

REM Pause to keep the command window open
pause
