
#Which folder (under the synced folder in the vagrantfile) contains your project source code.
DEV_FOLDER='app'

#Set the url for the website that you want to use during development
DEV_URL='dev.bradball.net'

#Which folder (under the synced folder in the vagrantfile) contains your compiled production ready code.
DIST_FOLDER='www'

#Set the url for the website that you want to use to view/test the compiled code.
DIST_URL='dist.bradball.net'

#Set the password used for various logins and accounts. mysql root, etc.
PASSWORD='hotrize'

echo "============================================================="
echo " RUNNING PROVISIONING SCRIPT NOW ..."
echo "============================================================="

#use eth1 for private network, eth0 for public
IP_ADDRESS=`/sbin/ifconfig eth1 | grep 'inet addr' | awk -F' ' '{print $2}' | awk -F':' '{print $2}'`

echo "Installing php7 ..."
sudo a2dismod php5

sudo rm /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get -y update

#sudo apt-get purge php5-common -y
sudo apt-get install -y php7.0

sudo apt-get update

sudo apt-get install -y php7.0-mysql php-curl libapache2-mod-php7.0 php7.0-mbstring

#sudo apt-get --purge autoremove -y

echo "Setting php timezone ..."
sudo sed -i 's/^;\(date\.timezone\) =\s*$/\1 = "America\/Kentucky\/Louisville"/g' /etc/php/7.0/cli/php.ini
sudo sed -i 's/^;\(date\.timezone\) =\s*$/\1 = "America\/Kentucky\/Louisville"/g' /etc/php/7.0/apache2/php.ini

sudo a2enmod php7.0

echo "Enable mod rewrite ..."
sudo a2enmod rewrite


#Add The server name to the hosts file
echo "Setup the hosts file ..."
sudo echo "127.0.0.1  ${DEV_URL}" >> /etc/hosts
sudo echo "127.0.0.1  ${DIST_URL}" >> /etc/hosts

# setup the VirtualHost entry in the apache config file
echo "Setup the virtual host in the apache config ..."
VHOST_DEV=$(cat <<EOF
<VirtualHost *:80>
	ServerName "${DEV_URL}"
	EnableSendfile Off
    DirectoryIndex index.php index.html
    DocumentRoot "/var/www/html/${DEV_FOLDER}"
    <Directory "/var/www/html/${DEV_FOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST_DEV}" > "/etc/apache2/sites-available/${DEV_URL}.conf"
sudo a2ensite "${DEV_URL}.conf"

# setup the VirtualHost entry in the apache config file
echo "Setup the virtual host in the apache config ..."
VHOST_DIST=$(cat <<EOF
<VirtualHost *:80>
	ServerName "${DIST_URL}"
	EnableSendfile Off
    DirectoryIndex index.php index.html
    DocumentRoot "/var/www/html/${DIST_FOLDER}"
    <Directory "/var/www/html/${DIST_FOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST_DIST}" > "/etc/apache2/sites-available/${DIST_URL}.conf"
sudo a2ensite "${DIST_URL}.conf"

#disable the default site
sudo a2dissite 000-default.conf

sudo service apache2 restart

echo "================================================================"
echo " YOUR VAGRANT BOX IS ALL READY TO GO!"
echo " The following sites are setup: "
echo " "
echo " http://${DEV_URL}     (Document Root: ${DEV_FOLDER} folder)"
echo " http://${DIST_URL}    (Document Root: ${DIST_FOLDER} folder)"
echo " "
echo " Don't forget to add entries for these sites to your hosts file."
echo " The IP Address is: ${IP_ADDRESS}"
echo "================================================================"
