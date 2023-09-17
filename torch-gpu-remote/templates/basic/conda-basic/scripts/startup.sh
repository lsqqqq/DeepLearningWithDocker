#!/bin/bash
# Warning: DO NOT modify this file, or the container may not be able to connect after restart!

# Change root password
echo "root:$ROOT_PASSWD" | chpasswd
# Alter frp settings with current environmental value
sed -i "s/SERVER_IP/$SERVER_IP/g" /root/frp_0.47.0_linux_amd64/frpc.ini
sed -i "s/SERVER_PORT/$SERVER_PORT/g" /root/frp_0.47.0_linux_amd64/frpc.ini

# Start ssh service
service ssh start

# Start frp service (uncomment to enable auto start on boot)
if [ $ENABLE_FRP == True ]
then
    echo "Starting frp service"
    nohup /root/frp_0.47.0_linux_amd64/frpc -c /root/frp_0.47.0_linux_amd64/frpc.ini  > /root/nohup_frp.log 2>&1 &
fi

# Keep client alive
/bin/bash