FROM nvidia/cuda:12.0.0-base-ubuntu22.04
MAINTAINER lsq<shangqinglyu@outlook.com>
ENV ROOT_PASSWD=ROOT_PASSWD SERVER_IP=SERVER_IP SERVER_PORT=SERVER_PORT
WORKDIR /root/

# Copy scripts from file
COPY scripts/* /root/scripts/

# Prepare for basic environment
RUN echo "export LANG=C.UTF-8" >>/etc/profile \
&& apt-get update \
&& apt-get install vim openssh-server iputils-ping wget curl -y \
&& sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
&& echo "root:$ROOT_PASSWD" | chpasswd \
# Prepare for MiniConda
&& chmod 777 /root/scripts/miniconda-install.sh \
&& bash /root/scripts/miniconda-install.sh \
# Prepare for frpc
&& tar -zxvf /root/scripts/frp_0.47.0_linux_amd64.tar.gz -C /root/\
&& mv frpc.ini /root/frp_0.47.0_linux_amd64/frpc.ini \
# Prepare for boot-up init script
&& chmod 777 /root/scripts/startup.sh \
# Modify welcome message
&& mv welcome-message /etc/update-motd.d/10-help-text \
&& rm -rf /etc/update-motd.d/60-unminimize

# Prepare for Conda environment
RUN chmod 777 /root/scripts/conda-torch-gpu-setup.sh \
&& bash /root/scripts/conda-torch-gpu-setup.sh

ENTRYPOINT /root/scripts/startup.sh

