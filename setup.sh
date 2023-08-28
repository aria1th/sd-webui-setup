# clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
# switch branch to origin/dev
git checkout origin/dev
# match to commit https://github.com/AUTOMATIC1111/stable-diffusion-webui/commit/ad266d795e08f8316e2a60566513f7115b7407d5
git checkout ad266d795e08f8316e2a60566513f7115b7407d5

# find python command to create venv
# from python3.11 to python3.10, else, use python3 
# set 'python_command' to available python version
python_command=python3.10
if ! command -v $python_command &> /dev/null
then
    python_command=python3
    echo "python3.10 not found, using python3"
fi

# read and extend webui-user-args.txt to at the end of webui-user.sh
# readlines from ../webui-user-args.txt
while read -r line; do
    echo $line >> webui-user.sh
done < ../webui-user-args.txt

echo 'python_cmd="'$python_command'"' >> webui-user.sh

# clone required repositories to stable-diffusion-webui/extensions/

# check if extensions folder exists
if [ ! -d "extensions" ]; then
    mkdir extensions
fi
cd extensions

# clone, read from extensions.txt
while read -r line; do
    git clone $line
done < ../../extensions.txt


# finally
cd ..
# now at stable-diffusion-webui/

# download models to stable-diffusion-webui/models/Stable-diffusion/
# read from sd-models.txt 
# <url> <optional_model_name>

while read -r line; do
    # split line into array
    IFS=' ' read -ra ADDR <<< "$line"
    # download model, save as <optional_model_name> if exists, else save as <url>
    if [ -z "${ADDR[1]}" ]; then
        wget -O models/Stable-diffusion/${ADDR[0]##*/} ${ADDR[0]}
    else
        wget -O models/Stable-diffusion/${ADDR[1]} ${ADDR[0]}
    fi
done < ../sd-models.txt

# run webui.sh
./webui.sh
# then