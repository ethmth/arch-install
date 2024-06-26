#!/bin/bash

if ! [ -f "/opt/models/model.gguf" ]; then
    echo "models/model.gguf not provided."
    exit 1
fi

python3 /usr/local/koboldcpp-rocm/koboldcpp.py --threads 6 --blasthreads 6 --gpulayers 12 --blasbatchsize 256 --contextsize 8192 --model /opt/models/model.gguf --usecublas mmq lowvram