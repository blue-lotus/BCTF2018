#!/bin/sh
# Add your startup script

# DO NOT DELETE
cd /guess_polynomial
socat TCP-LISTEN:1337,fork,reuseaddr EXEC:"timeout 30 python -u main.py"
# /etc/init.d/xinetd start;
# sleep infinity;
