FROM anupkumar/docker-ml-jupyterlab:galaxy-integration-0.2

USER root
RUN apt install unzip -y

RUN pip install torch==1.8.1 pytorch-lightning==1.2.6

USER gpuuser
# RUN conda update --all -y
