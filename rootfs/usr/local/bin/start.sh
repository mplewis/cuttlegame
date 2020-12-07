#!/bin/bash
set -exo pipefail

PASSWORD="${PASSWORD:-$(openssl rand -base64 12)}"
set -u

echo -n "$PASSWORD" > /.password1
x11vnc -storepasswd "$(cat /.password1)" /.password2
chmod 400 /.password*
sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf

set +x
echo -e "\033[0;32m"
cat <<EOF
 a88888b.            dP     dP   dP
d8'   \`88            88     88   88
88        dP    dP d8888P d8888P 88 .d8888b. .d8888b. .d8888b. 88d8b.d8b. .d8888b.
88        88    88   88     88   88 88ooood8 88'  \`88 88'  \`88 88'\`88'\`88 88ooood8
Y8.   .88 88.  .88   88     88   88 88.  ... 88.  .88 88.  .88 88  88  88 88.  ...
 Y88888P' \`88888P'   dP     dP   dP \`88888P' \`8888P88 \`88888P8 dP  dP  dP \`88888P'
                                                  .88
                                              d8888P

Connect to your Cuttlegame instance in your web browser:
http://localhost:8000?scale=local&password=$PASSWORD
EOF

echo -e "\033[0m"
set -x

export PASSWORD=

pulseaudio --start
exec /bin/tini -- supervisord -n -c /etc/supervisor/supervisord.conf
