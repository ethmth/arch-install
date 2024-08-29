#!/bin/bash

echo -n "$1" | xxd -r -p | base64
