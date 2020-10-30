#!/bin/bash -e

RP=$1
ADMIN_PASS=$2
DOMAIN1=$3
DOMAIN2=$4
RP_PASS=$5
MASTER_IP=$6

service slapd start

if [ $RP -eq 0 ]; then
    /root/rpmaster.sh $RP $ADMIN_PASS $DOMAIN1 $DOMAIN2 $RP_PASS
else
    /root/rpslave.sh $RP $ADMIN_PASS $DOMAIN1 $DOMAIN2 $RP_PASS $MASTER_IP
fi

service slapd stop
