FROM anupkumar/docker-ml-jupyterlab:galaxy-integration-0.2

USER root
RUN apt update && apt install unzip netcat-openbsd dnsutils -y

RUN pip install torch==1.8.1 pytorch-lightning==1.2.6 tensorboard_logger tensorboard_plugin_profile
RUN pip install lightgbm==2.2.3 tsfresh==0.19.0

EXPOSE 6006

USER gpuuser
# RUN conda update --all -y
