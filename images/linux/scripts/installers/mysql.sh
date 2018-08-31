#!/bin/bash
################################################################################
##  File:  mysql.sh
##  Team:  CI-Platform
##  Desc:  Installs MySQL Client
################################################################################

## Source the helpers for use with the script
source $HELPER_SCRIPTS/document.sh

export ACCEPT_EULA=Y

# Install MySQL Client
apt-get install mysql-client -y

# Install MySQL Server
MYSQL_ROOT_PASSWORD=root
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | debconf-set-selections

apt-get install -y mysql-server

# Install MS SQL Server client tools (https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-2017)
# curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# curl "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list" | tee /etc/apt/sources.list.d/msprod.list
# apt-get update
apt-get install -y mssql-tools unixodbc-dev
apt-get -f install
ln -s /opt/mssql-tools/bin/* /usr/local/bin/

# Run tests to determine that the software installed as expected
echo "Testing to make sure that script performed as expected, and basic scenarios work"
if ! command -v mysql; then
    echo "mysql was not installed"
    exit 1
fi

# Document what was added to the image
echo "Lastly, documenting what we added to the metadata file"
DocumentInstalledItem "MySQL ($(mysql --version))"
DocumentInstalledItem "MySQL Server"
DocumentInstalledItem "MS SQL Server Client Tools"
