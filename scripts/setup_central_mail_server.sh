#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run receiving_mail_server_setup.sh script ##################'
echo '##########################################################################'

yum install -y postfix
cp /etc/postfix/main.cf /etc/postfix/main.cf-orig

postconf -e myhostname=$(hostname)
postconf -e mydomain=cb.net
postconf -e myorigin='$myhostname'
postconf -e inet_interfaces=all
postconf -e mydestination='$myhostname, localhost.$mydomain, localhost, $mydomain'
# see the following for more info about these settings:
# man 5 postconf

postconf -e mynetworks=10.1.0.0/24

# this is something needed for our vagrant setup only, since our vagrant setup doesn't include
# a dns server. 
postconf -e disable_dns_lookups=yes


# the following checks for any config related errors. 
postfix check


# this deisplays all the default settings
postconf -d
# this displays all the explicitly defined settings
postconf -n


firewall-cmd --permanent --add-service=smtp
systemctl restart firewalld.service


systemctl enable postfix
systemctl restart postfix


# now we test this locally:

useradd tom

yum install -y mailx
echo 'hello world' | mail -s 'test email' tom@localhost




exit 0