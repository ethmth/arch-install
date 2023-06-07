FROM python:3.10-bullseye

RUN apt update && apt upgrade -y && apt install wget git python3 python3-venv -y

RUN useradd -m user
USER user
# RUN mkdir -p /home/user
WORKDIR /home/user

# RUN cd /home/user
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git


RUN bash stable-diffusion-webui/webui.sh

# bash <(wget -qO- https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh)


ENTRYPOINT ["bash","stable-diffusion-webui/webui.sh"]
CMD [""]