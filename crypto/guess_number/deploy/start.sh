#!/bin/sh
# Add your startup script

# DO NOT DELETE
cd /guess_number
socat TCP-LISTEN:1337,fork,reuseaddr EXEC:"timeout 200 python -u main.py"
# /etc/init.d/xinetd start;
# sleep infinity;
