FROM ubuntu:bionic
ENV JUPYTERLAB_VERSION 1.1.0
ENV USER_BINDER jovyan
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && echo "America/Mexico_City" > /etc/timezone && apt-get install -y tzdata

RUN apt-get update && apt-get install -y \
	    build-essential \
            sudo \
            nano \
            less \
            git \
            python3-dev \
            python3-pip \
            python3-setuptools \
            nodejs && pip3 install --upgrade pip
            
RUN git clone https://github.com/optimizacion-2-2021-1-gh-classroom/practica-1-segunda-parte-yefovar.git /home/jovyan/practica-1-segunda-parte-yefovar
RUN pip install /home/jovyan/practica-1-segunda-parte-yefovar/src/
            

RUN groupadd ${USER_BINDER}
RUN useradd ${USER_BINDER} -g ${USER_BINDER} -m -s /bin/bash
RUN echo 'jovyan ALL=(ALL:ALL) NOPASSWD:ALL' | (EDITOR='tee -a' visudo)
RUN echo 'jovyan:qwerty' | chpasswd
RUN pip3 install jupyter jupyterlab==$JUPYTERLAB_VERSION --upgrade
RUN chown -R ${USER_BINDER}:${USER_BINDER} /home/jovyan/   #da permisos al usuario
USER ${USER_BINDER}
RUN jupyter notebook --generate-config && sed -i "s/#c.NotebookApp.password = .*/c.NotebookApp.password = u'sha1:115e429a919f:21911277af52f3e7a8b59380804140d9ef3e2380'/" /home/jovyan/.jupyter/jupyter_notebook_config.py
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
