#!/bin/bash
useradd $USR
usermod -d /$USR $USR

cp -R /root /$USR

chown -R $USR /$USR
rm -rf /tmp/.X1*

launch="vncserver :1 -geometry $RES -depth 32 -localhost no -httpPort 5900 -verbose"
su -c "bash -c \"echo -e '$PAS\n$PAS\nn' | $launch\"" $USR
su -c "tail -F /$USR/.vnc/*.log" $USR