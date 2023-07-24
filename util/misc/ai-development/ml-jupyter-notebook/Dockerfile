FROM anupkumar/docker-ml-jupyterlab:galaxy-integration-0.2

USER root
RUN apt install unzip netcat-openbsd -y

RUN pip install torch==1.8.1 pytorch-lightning==1.2.6 tensorboard==2.2.0

EXPOSE 6006

USER gpuuser
# RUN conda update --all -y
