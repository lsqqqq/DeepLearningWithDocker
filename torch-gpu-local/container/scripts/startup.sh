#!/bin/bash
# Warning: DO NOT modify this file, or the container may not be able to connect after restart!

# Change root password
echo "root:$ROOT_PASSWD" | chpasswd

# Start ssh service
service ssh start

# Keep client alive
/bin/bash