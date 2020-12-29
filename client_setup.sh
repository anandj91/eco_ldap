. eco_ldap.conf

export DEBIAN_FRONTEND=noninteractive

sudo apt install debconf-utils

echo "ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://${MASTER_IP}" | debconf-set-selections;\
echo "ldap-auth-config ldap-auth-config/ldapns/base-dn string dc=${DOMAIN1},dc=${DOMAIN2}" | debconf-set-selections;\
echo "ldap-auth-config ldap-auth-config/ldapns/ldap_version select 3" | debconf-set-selections;\
echo "ldap-auth-config ldap-auth-config/dbrootlogin boolean true" | debconf-set-selections;\
echo "ldap-auth-config ldap-auth-config/dblogin boolean false" | debconf-set-selections;\
echo "ldap-auth-config ldap-auth-config/rootbinddn string cn=admin,dc=${DOMAIN1},dc=${DOMAIN2}" | debconf-set-selections;\
echo "ldap-auth-config ldap-auth-config/rootbindpw password ${ADMIN_PASS}" | debconf-set-selections;\
sudo apt install libnss-ldap libpam-ldap ldap-utils nscd -y

sudo sed -i "/^passwd:.*[^p]$/ s/$/ ldap/" /etc/nsswitch.conf
sudo sed -i "/^group:.*[^p]$/ s/$/ ldap/" /etc/nsswitch.conf
sudo sed -i "/^shadow:.*[^p]$/ s/$/ ldap/" /etc/nsswitch.conf

sudo sed -i "s/pam_ldap.so use_authtok/pam_ldap.so/" /etc/pam.d/common-password
echo "session optional pam_mkhomedir.so skel=/etc/skel umask=077" >> /etc/pam.d/common-session
