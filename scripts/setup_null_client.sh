#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '############### About to run setup_sending_mail_server.sh script ##################'
echo '##########################################################################'


yum install -y postfix

cp /etc/postfix/main.cf /etc/postfix/main.cf-orig


exit 0



postconf -e myhostname=$(hostname)
postconf -e mydomain=example.com
postconf -e myorigin='$mydomain'
postconf -e inet_interfaces=localhost
postconf -e mydestination=''           # this is intentionally left blank
postconf -e mynetworks=127.0.0.1/8
postconf -e relayhost=[central-mail-server.example.com]


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



systemctl enable postfix
systemctl start postfix


useradd jerry
yum install -y mailx
su -c 'echo "hello tom, this is jerry" | mail -s "test email" tom@central-mail-server.example.com' jerry

exit 0