#!/bin/bash
# My Telegram : https://t.me/geovpn
# ━━━━━━━━━━━━━━━━━━━━━==============
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ━━━━━━━━━━━━━━━━━━━━━==============
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
exp=$(curl -sS https://raw.githubusercontent.com/calistahazel/script/allow | grep $MYIP | awk '{print $3}')
serverdate=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date=`date +"%Y-%m-%d" -d "$serverdate -1 days"`
if [[ $date = $exp ]]; then
echo -e "${NC}${RED}Permission Denied !${NC}"
echo -e "${NC}${RED}Your Script Expired !${NC}"
exit 0
else
echo -e "${NC}${GREEN}Permission Accepted !${NC}";
fi
sleep 1
clear
if [[ "$IP" = "" ]]; then
PUBLIC_IP=$(wget -qO- ipinfo.io/ip);
else
PUBLIC_IP=$IP
fi
source /var/lib/geovpn/ipvps.conf
if [[ "$IP2" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP2
fi
VPN_USER=dev-`</dev/urandom tr -dc X-Z0-9 | head -c4`
VPN_PASSWORD=1
masaaktif=1
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
clear

# Add or update VPN user
cat >> /etc/ppp/chap-secrets <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
cat >> /etc/ipsec.d/passwd <<EOF
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $VPN_USER $exp">>"/var/lib/geovpn/data-user-l2tp"
cat <<EOF

━━━━━━━━━━━━━━━━━━━━━
L2TP/IPSEC PSK VPN
━━━━━━━━━━━━━━━━━━━━━
IP/Host    : $PUBLIC_IP
Domain     : $domain
IPsec PSK  : myvpn
Username   : $VPN_USER
Password   : $VPN_PASSWORD
Created    : $hariini
Expired    : $exp
━━━━━━━━━━━━━━━━━━━━━
Script By geovpn
EOF