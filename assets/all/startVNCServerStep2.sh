#! /bin/bash

if [[ -z "${INITIAL_USERNAME}" ]]; then
  INITIAL_USERNAME="user"
fi

if [[ -z "${INITIAL_VNC_PASSWORD}" ]]; then
  INITIAL_VNC_PASSWORD="userland"
fi

if [ ! -f /home/$INITIAL_USERNAME/.vnc/passwd ]; then
  mkdir /home/$INITIAL_USERNAME/.vnc 
  x11vnc -storepasswd $INITIAL_VNC_PASSWORD /home/$INITIAL_USERNAME/.vnc/passwd
fi

if [[ -z "${DIMENSIONS}" ]]; then
  DIMENSIONS="1024x768"
fi

if [[ -z "${VNC_DISPLAY}" ]]; then
  VNC_DISPLAY="51"
fi

rm /tmp/.X${VNC_DISPLAY}-lock
Xvfb :${VNC_DISPLAY} -screen 0 ${DIMENSIONS}x16 &
sleep 2
export DISPLAY=:${VNC_DISPLAY}
cd ~
xterm -geometry 80x24+0+0 -e /bin/bash --login &
x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :${VNC_DISPLAY} -N -usepw -shared -noshm &
VNC_PID=$!
echo $VNC_PID > /home/$INITIAL_USERNAME/.vnc/localhost:${VNC_DISPLAY}.pid
LANG=C startxfce4
