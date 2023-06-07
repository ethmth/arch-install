FROM python:3.10-bullseye

RUN apt update && apt upgrade -y && apt install wget git python3-venv -y
RUN pip3 install importlib

RUN useradd -m user
USER user
WORKDIR /home/user/stable-diffusion-webui

# ENTRYPOINT ["bash","webui.sh"]
# CMD [""]

# CMD ["bash","webui.sh"]
# CMD "./webui.sh"
CMD "bash delay.sh"
# CMD ["bash","webui.sh"]
