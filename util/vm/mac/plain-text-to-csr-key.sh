#!/bin/bash


echo -n "$1" | base64 --decode | xxd -p