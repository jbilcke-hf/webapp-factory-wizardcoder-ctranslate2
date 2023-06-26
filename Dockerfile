FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
LABEL maintainer="Hugging Face"

ENV PYTHONUNBUFFERED 1

EXPOSE 7860

ARG DEBIAN_FRONTEND=noninteractive

# Use login shell to read variables from `~/.profile` (to pass dynamic created variables between RUN commands)
SHELL ["sh", "-lc"]

RUN apt update

RUN apt --yes install curl

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

RUN apt --yes install nodejs

RUN apt --yes install git git-lfs libsndfile1-dev tesseract-ocr espeak-ng python3 python3-pip ffmpeg

RUN git lfs install

RUN python3 -m pip install --no-cache-dir --upgrade pip

RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

WORKDIR $HOME/app

COPY --chown=user package*.json .

RUN npm install

COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Required to activate GPU in CTransformers
# ENV CT_CUBLAS 1

# Install CTransformers without pre-built CPU modules
# RUN pip install ctransformers --no-binary ctransformers

COPY --chown=user . .

# a limitation of Pythonia is that async calls can timeout
# so we perform the slow operation of downloading the model to cache beforehand
RUN python3 download-model.py

# help Pythonia by giving it the path to Python
ENV PYTHON_BIN /usr/bin/python3

CMD [ "npm", "run", "start" ]