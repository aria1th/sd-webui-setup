@echo off
REM clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
REM switch branch to origin/dev
git checkout origin/dev
REM match to commit https://github.com/AUTOMATIC1111/stable-diffusion-webui/commit/ad266d795e08f8316e2a60566513f7115b7407d5
git checkout ad266d795e08f8316e2a60566513f7115b7407d5

REM find python command to create venv
REM from python3.11 to python3.10, else, use python3 
REM set 'python_command' to available python version
set python_command=python3.10
where %python_command% >nul 2>nul || (
    set python_command=python3
    echo python3.10 not found, using python3
)

REM extend webui-user-args.txt to at the end of webui-user.sh
REM from ../webui-user-args.txt
type ..\webui-user-args.txt >> webui-user.sh 

echo python_cmd="%python_command%" >> webui-user.sh

REM clone required repositories to stable-diffusion-webui/extensions/

REM check if extensions folder exists
if not exist "extensions" mkdir extensions
cd extensions

REM clone, read from extensions.txt
for /f "delims=" %%i in (..\..\extensions.txt) do git clone %%i

REM finally
cd ..
REM now at stable-diffusion-webui/

REM download models to stable-diffusion-webui/models/Stable-diffusion/
REM read from sd-models.txt 
REM <url> <optional_model_name>

for /f "tokens=1,*" %%i in (sd-models.txt) do (
    REM split line into array
)