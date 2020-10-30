#!/bin/bash -e

RP=$1
ADMIN_PASS=$2
DOMAIN1=$3
DOMAIN2=$4
RP_PASS=$5

echo -e "dn: uid=rpuser,dc=$DOMAIN1,dc=$DOMAIN2\n\
objectClass: simpleSecurityObject\n\
objectclass: account\n\
uid: rpuser\n\
description: Replication User\n\
userPassword: $RP_PASS" | ldapadd -x -w $ADMIN_PASS -D "cn=admin,dc=$DOMAIN1,dc=$DOMAIN2"
echo -e "dn: cn=module{0},cn=config\n\
changetype: modify\n\
add: olcModuleLoad\n\
olcModuleLoad: syncprov.la" | ldapmodify -Y EXTERNAL -H ldapi:///
echo -e "dn: olcOverlay=syncprov,olcDatabase={1}mdb,cn=config\n\
objectClass: olcOverlayConfig\n\
objectClass: olcSyncProvConfig\n\
olcOverlay: syncprov\n\
olcSpSessionLog: 100" | ldapadd -Y EXTERNAL -H ldapi:///
