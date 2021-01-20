#!/bin/bash
touch /root/.vnc/passwd
bash -c "echo -e '$PASS\n$PASS\nn' | vncpasswd" > /root/.vnc/passwd
chmod 400 /root/.vnc/passwd
chmod go-rwx /root/.vnc
vncserver :1 -geometry 1920x1080 -depth 24 && tail -F /root/.vnc/*.log