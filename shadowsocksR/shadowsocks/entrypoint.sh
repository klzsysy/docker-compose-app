#!/usr/bin/env bash
# Docker script to configure and start an shadowsocks server
# author: sonny
# Email: klzsysy@gmail.com

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[  -z "${PORT}" ] && PORT=9990 ;
[ -z "${PASSWORD}" ] && PASSWORD=sonny.201707


kernel_version=$(uname -r | awk -F'.' '{printf "%s.%s",$1,$2}')
echo "${kernel_version} 3.7" | awk  '{if($1>=$2) {print "ok"}}' | grep -q 'ok'
[ $? -eq 0 ] && ARGS="${ARGS} --fast-open"

if [ -z "${PROTOCOL}" ];then
    ARGS_PROTOCOL=""
else
    ARGS_PROTOCOL="-O ${PROTOCOL}"
fi

if [ -z "${OBFS}" ];then
    ARGS_OBFS=""
else
    ARGS_OBFS="-o ${OBFS}"
fi


PUBLIC_IP=$(curl -s ifconfig.co)

# log in start info
cat <<EOF
=================================================================
Shadowsocksr server is now ready for use!
Connect to your ssr server with these details:
Server IP   :   ${PUBLIC_IP}
Port        :   ${PORT}
Password    :   ${PASSWORD}
Encryption  :   ${METHOD}
Protocol    :   ${PROTOCOL}
Bbfs        :   ${OBFS}
More_Args   :   ${ARGS}

Windows clients: https://github.com/shadowsocksr/shadowsocksr-csharp/releases
MacOS clients: https://github.com/shadowsocksr/ShadowsocksX-NG

PS: If you are using cloud services, please open the cloud firewall port ${PORT}
=================================================================
EOF

echo "python server.py -p ${PORT} -k ${PASSWORD} -m ${METHOD} ${ARGS_PROTOCOL} ${ARGS_OBFS} ${ARGS}"
python server.py -p ${PORT} -k ${PASSWORD} -m ${METHOD} ${ARGS_PROTOCOL} ${ARGS_OBFS} ${ARGS}
