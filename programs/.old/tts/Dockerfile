FROM ghcr.io/coqui-ai/tts

ENTRYPOINT ["/bin/bash"]
#CMD ["-c", "python3 TTS/server/server.py --list_models"]
CMD ["-c", "python3 TTS/server/server.py --model_name tts_models/en/vctk/vits --use_cuda true"]