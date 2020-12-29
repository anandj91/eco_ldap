
# EcoSystem LDAP Authentication server

eco_ldap contains a docker setup to create an LDAP-based user authentication server. This include the following:

 1. LDAP server to store user and group information
 2. LAM server for updating LDAP server with the help of a web portal.
 3. Makefile to build and deploy both LDAP and LAM
 4. Script to configure client machine to connect to the LDAP server

## How to use
There is a Makefile prepared to do all the setup necessary to install, configure and deploy the LDAP server and LAM server. Edit *eco_ldap.conf* file to update configuration parameters before setting up the docker container. Only need to set the parameters `ADMIN_PASS` and `MASTER_IP` for basic functionality. Everything else can be left with default values.

### Setting up LDAP/LAM server
Following Makefile targets might be helpful:

 1. `make build` - Creates the docker image with fully configured fresh LDAP and LAM servers. 
 2. `make run` - Deploys a docker container containing LDAP and LAM servers with all the relevant ports exposed to the host machine. LAM server is accessible at port 8080
 3. `make backup` - Backup the LDAP server and store as .ldif files in the directory *./backup*. The docker container also configured to periodically backup the LDAP server every 15 minutes.
 4. `make restore` - Restore the LDAP server from the most recent backed up *.ldif files.
 5. `make clean` - Destroy the LDAP/LAM docker container

Once the server is setup, you can access LAM server through <MASTER_IP>:8080/lam. To change the LAM password, follow https://www.linux.com/news/how-install-ldap-account-manager-ubuntu-server-1804/

### Configure the client machine
Set the same configuration parameters in *eco_ldap.conf* used for server setup. Then just run `./client_setup.sh` script.

## Future work

 1. Configure LDAP server with master-slave replication

## References
https://www.linux.com/topic/desktop/how-install-openldap-ubuntu-server-1804/
https://www.linux.com/news/how-install-ldap-account-manager-ubuntu-server-1804/
https://www.linux.com/topic/desktop/how-authenticate-linux-desktop-your-openldap-server/
