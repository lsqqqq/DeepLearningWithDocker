FROM dl-basic:1.0-nvcc-conda
MAINTAINER lsq<shangqinglyu@outlook.com>
ENV ROOT_PASSWD=ROOT_PASSWD SERVER_IP=SERVER_IP SERVER_PORT=SERVER_PORT
WORKDIR /root/

# Prepare for Conda environment: python38
RUN chmod 777 /root/scripts/conda-torch-gpu-setup-python38.sh \
&& bash /root/scripts/conda-torch-gpu-setup-python38.sh

# Prepare for Conda environment: python39
RUN chmod 777 /root/scripts/conda-torch-gpu-setup-python39.sh \
&& bash /root/scripts/conda-torch-gpu-setup-python39.sh

ENTRYPOINT /root/scripts/startup.sh
