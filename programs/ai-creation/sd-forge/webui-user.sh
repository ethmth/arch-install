#!/bin/bash
export COMMANDLINE_ARGS="--listen --port 7680 --gradio-auth user:password --allow-code --enable-insecure-extension-access --api --api-auth username:password"
python_cmd="python"
export TORCH_COMMAND="pip install torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2 --index-url https://download.pytorch.org/whl/rocm5.4.2"
