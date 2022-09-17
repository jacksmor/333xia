#!/bin/sh
##

# Set ARG
ARCH="64"
DOWNLOAD_PATH="/tmp/v2ray"

mkdir -p ${DOWNLOAD_PATH}
cd ${DOWNLOAD_PATH} || exit

wget -O ${DOWNLOAD_PATH}/v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.2/v2ray-linux-64.zip

# Prepare
echo "Prepare to use"
unzip v2ray.zip && chmod +x v2ray v2ctl
mv v2ray v2ctl /usr/bin/
mv geosite.dat geoip.dat /usr/local/share/v2ray/
# mv config.json /etc/v2ray/config.json

# Set config file
cat <<EOF >/etc/v2ray/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 8080,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "482a3319-aa83-43fe-bc5d-3ae61b05d63f",
                        "alterId": 0
                    }
                ],
                "disableInsecureEncryption": true
            },
            "streamSettings": {
                "network": "ws"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Clean
cd ~ || return
rm -rf ${DOWNLOAD_PATH:?}/*
echo "Install done"

echo "--------------------------------"
echo "Fly App Name: ${FLY_APP_NAME}"
echo "Fly App Region: ${FLY_REGION}"
echo "V2Ray UUID: ${UUID}"
echo "--------------------------------"

# Run v2ray
/usr/bin/v2ray -config /etc/v2ray/config.json
