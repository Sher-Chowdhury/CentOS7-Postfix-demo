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


# the following checks for any config related errors. 
postfix check
# this deisplays all the default settings
postconf -d
# this displays all the explicitly defined settings
postconf -n

postconf -e myhostname=$(hostname)
postconf -e mydomain=example.com
postconf -e local_transport='error: this is a null client'
postconf -e myorigin='$myhostname'
postconf -e inet_interfaces=loopback-only
postconf -e mydestination=''           # this is intentionally left blank
postconf -e mynetworks='127.0.0.0/8 [::1]/128'
postconf -e relayhost=[central-mail-server.example.com]

postfix check


systemctl restart postfix

useradd jerry
yum install -y mailx
su -c 'echo "hello tom, this is jerry" | mail -s "test email" tom@central-mail-server.example.com' jerry

# the following works as long as I specify an fqdn of target box, if I omit 'mail-client' then it stops working:
echo "hello tom, this is jerry" | mail -s "test email" matt@mail-client.example.com

# note no need to do any firewalld stuff since service is not listening on any external facing network interfaces
exit 0