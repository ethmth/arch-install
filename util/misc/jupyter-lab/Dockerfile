FROM jupyter/tensorflow-notebook:latest

# COPY requirements.txt /tmp/

# RUN pip install -r /tmp/requirements.txt && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER

RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

ENTRYPOINT ["start.sh", "jupyter", "lab", "--NotebookApp.token=''", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]