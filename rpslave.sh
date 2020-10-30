#!/bin/bash -e

RP=$1
ADMIN_PASS=$2
DOMAIN1=$3
DOMAIN2=$4
RP_PASS=$5
MASTER_IP=$6

echo -e "dn: olcDatabase={1}mdb,cn=config\n\
changetype: modify\n\
add: olcSyncRepl\n\
olcSyncRepl: rid=00${RP}\n\
  provider=ldap://${MASTER_IP}:389/\n\
  bindmethod=simple\n\
  binddn=\"uid=rpuser,dc=${DOMAIN1},dc=${DOMAIN2}\"\n\
  credentials=${RP_PASS}\n\
  searchbase=\"dc=${DOMAIN1},dc=${DOMAIN2}\"\n\
  scope=sub\n\
  schemachecking=on\n\
  type=refreshAndPersist\n\
  retry=\"30 5 300 3\"\n\
  interval=00:00:05:00" | ldapmodify -Y EXTERNAL -H ldapi:///
