FROM ubuntu:20.04

RUN apt update -y
RUN apt upgrade -y
RUN apt install vim net-tools debconf-utils iputils-ping nmap telnet -y

ENV ADMIN_PASS="admin"
ENV DOMAIN1="syslab"
ENV DOMAIN2="sandbox"
ENV ORG="ecosystem"

# Install and configure slapd
RUN echo "slapd slapd/password1 password $ADMIN_PASS" | debconf-set-selections;\
echo "slapd slapd/password2 password $ADMIN_PASS" | debconf-set-selections;
RUN DEBIAN_FRONTEND=noninteractive apt install ldap-utils slapd -y

RUN echo "slapd slapd/password1 password $ADMIN_PASS" | debconf-set-selections;\
echo "slapd slapd/password2 password $ADMIN_PASS" | debconf-set-selections;\
echo "slapd slapd/no_configuration boolean false" | debconf-set-selections;\
echo "slapd slapd/domain string ${DOMAIN1}.${DOMAIN2}" | debconf-set-selections;\
echo "slapd shared/organization string $ORG" | debconf-set-selections;\
echo "slapd slapd/purge_database boolean false" | debconf-set-selections;\
echo "slapd slapd/move_old_database boolean true" | debconf-set-selections;
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure slapd

# Install LAM
RUN echo "tzdata tzdata/Areas select America" | debconf-set-selections;\
echo "tzdata tzdata/Zones/America select Toronto" | debconf-set-selections;
RUN DEBIAN_FRONTEND=noninteractive apt install ldap-account-manager -y

RUN sed -i "s/dc=yourdomain,dc=org/dc=$DOMAIN1,dc=$DOMAIN2/g" \
    /var/lib/ldap-account-manager/config/lam.conf
RUN sed -i "s/dc=my-domain,dc=com/dc=$DOMAIN1,dc=$DOMAIN2/g" \
    /var/lib/ldap-account-manager/config/lam.conf
RUN sed -i "s/cn=Manager,dc=$DOMAIN1,dc=$DOMAIN2/cn=admin,dc=$DOMAIN1,dc=$DOMAIN2/g" \
    /var/lib/ldap-account-manager/config/lam.conf

# Configure secure ldap
#RUN apt install openssh-server -y
#RUN mkdir -v /etc/ldap/ssl
#RUN openssl req -newkey rsa:1024 -x509 -nodes \
#    -out /etc/ldap/ssl/slapd.pem -keyout /etc/ldap/ssl/slapd.pem -days 3650 \
#    -subj "/C=CA/ST=Ontario/L=Toronto/O=UofT/CN=Ecosystem"
#RUN chown -v openldap:openldap /etc/ldap/ssl/slapd.pem
#RUN chmod -v 400 /etc/ldap/ssl/slapd.pem
#RUN echo "TLSCACertificateFile  /etc/ldap/ssl/slapd.pem\n\
#TLSCertificateFile    /etc/ldap/ssl/slapd.pem\n\
#TLSCertificateKeyFile /etc/ldap/ssl/slapd.pem" | tee -a /etc/ldap/ldap.conf
#RUN sed -i "/^SLAPD_SERVICES/d" /etc/default/slapd
#RUN echo 'SLAPD_SERVICES="ldap:/// ldaps:/// ldapi:///"' \
#    | tee -a /etc/default/slapd

# Configure necessary for replication
ENV RP_PASS="rpuser"
ENV RP=0
ENV MASTER_IP="127.0.0.1"
ADD rpsetup.sh /root/
ADD rpmaster.sh /root/
ADD rpslave.sh /root/
ADD backup.sh /root/
ADD restore.sh /root/
RUN /root/rpsetup.sh $RP $ADMIN_PASS $DOMAIN1 $DOMAIN2 $RP_PASS $MASTER_IP

EXPOSE 80 389 636
VOLUME /backup
