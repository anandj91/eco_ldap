#!/bin/bash -e

DIR=$(find /backup/ -name "bck_*" | sort -nr | head -1)

pkill slapd

mv /etc/ldap/slapd.d /etc/ldap/slapd.d.`date '+%Y-%m-%d-%H-%M-%S'`
mkdir /etc/ldap/slapd.d
slapadd -n 0 -F /etc/ldap/slapd.d -l ${DIR}/config.ldif
chown -R openldap:openldap /etc/ldap/slapd.d

mv /var/lib/ldap /var/lib/ldap`date '+%Y-%m-%d-%H-%M-%S'`
mkdir /var/lib/ldap
slapadd -n 1 -F /etc/ldap/slapd.d -l ${DIR}/data.ldif -w
chown -R openldap:openldap /var/lib/ldap

service slapd start
