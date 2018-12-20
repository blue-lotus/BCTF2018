#!/bin/sh
# Add your startup script

# DO NOT DELETE
/usr/sbin/chroot --userspec=1000:1000 /home/ctf node ./index.js
sleep infinity;
