FROM python:3.10-bullseye

RUN apt update && apt upgrade -y && apt install wget git python3 python3-venv -y

RUN useradd -m user
USER user
WORKDIR /home/user/stable-diffusion-webui

ENTRYPOINT ["bash","webui.sh"]
CMD [""]