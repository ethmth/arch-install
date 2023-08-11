FROM gcr.io/kaggle-gpu-images/python

RUN pip install jupyter_contrib_nbextensions jupyter_nbextensions_configurator

RUN jupyter contrib nbextension install --user

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "jupyter notebook --notebook-dir=/opt/working --ip='*' --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''"]