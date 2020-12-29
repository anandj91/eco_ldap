#!/bin/bash -e
service slapd restart
service apache2 restart
cron

echo "Startup finished successfully. Going to sleep now forever. zzz"
sleep infinity
