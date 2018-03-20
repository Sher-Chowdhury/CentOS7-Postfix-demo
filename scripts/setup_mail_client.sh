#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '############### About to run setup_sending_mail_server.sh script ##################'
echo '##########################################################################'


yum install -y postfix

cp /etc/postfix/main.cf /etc/postfix/main.cf-orig



# see the following for more info about these settings:
# man 5 postconf

# this is something needed for our vagrant setup only, since our vagrant setup doesn't include
# a dns server. 
postconf -e disable_dns_lookups=yes
postconf -e inet_interfaces='127.0.0.1, 10.1.4.12'

# the following checks for any config related errors. 
postfix check
# this deisplays all the default settings
postconf -d
# this displays all the explicitly defined settings
postconf -n


firewall-cmd --add-service=smtp --permanent
systemctl restart firewalld.service



systemctl enable postfix
systemctl restart postfix


useradd matt
yum install -y mailx

exit 0