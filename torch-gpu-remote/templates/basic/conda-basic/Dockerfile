FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel
MAINTAINER lsq<shangqinglyu@outlook.com>
ENV ROOT_PASSWD=ROOT_PASSWD SERVER_IP=SERVER_IP SERVER_PORT=SERVER_PORT
WORKDIR /root/

# Copy scripts from file
COPY scripts/* /root/scripts/

# Prepare for basic environment
RUN echo "export LANG=C.UTF-8" >>/etc/profile \
&& apt-get update \
&& apt-get install -y dialog apt-utils \
&& DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata \
&& apt-get install vim openssh-server iputils-ping wget curl git htop tree gcc zip unzip ffmpeg libsm6 libxext6  -y \
&& sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
&& echo "root:$ROOT_PASSWD" | chpasswd \
&& ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa \
# Prepare for MiniConda
&& chmod 777 /root/scripts/miniconda-install.sh \
&& bash /root/scripts/miniconda-install.sh \
&& . /root/miniconda3/bin/activate \
&& conda update -n base -c defaults conda \
# Prepare for frpc
&& tar -zxvf /root/scripts/frp_0.47.0_linux_amd64.tar.gz -C /root/ \
&& cp /root/scripts/frpc.ini /root/frp_0.47.0_linux_amd64/frpc.ini \
# Prepare for boot-up init script
&& chmod 777 /root/scripts/startup.sh \
# Modify welcome message
&& cp /root/scripts/welcome-message /etc/update-motd.d/10-help-text \
&& rm -rf /etc/update-motd.d/60-unminimize

# # Prepare for Conda environment: python38
# RUN chmod 777 /root/scripts/conda-torch-gpu-setup-python38.sh \
# && bash /root/scripts/conda-torch-gpu-setup-python38.sh

# # Prepare for Conda environment: python39
# RUN chmod 777 /root/scripts/conda-torch-gpu-setup-python39.sh \
# && bash /root/scripts/conda-torch-gpu-setup-python39.sh

# Make sure the environment is the same when logged in as ssh
RUN echo "export PATH=${PATH}" >> /root/.bashrc

ENTRYPOINT /root/scripts/startup.sh
