FROM python:3.7

## Pip dependencies
# Upgrade pip
RUN pip install --upgrade pip

# Install production dependencies
# COPY functions/requirements.txt /tmp/requirements.txt
# COPY functions/requirements_dev.txt /tmp/requirements_dev.txt

# RUN pip install -r /tmp/requirements.txt && \
#     rm /tmp/requirements.txt
# RUN pip install -r /tmp/requirements_dev.txt && \
#     rm /tmp/requirements_dev.txt

RUN apt-get update
RUN apt-get install -y vim

