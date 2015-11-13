#!/bin/bash

# needs to match puppet hieradata .yaml file
SERVER_NAME=padi.pih-emr.org

# grab some configs from puppet config
MYSQL_ROOT_PASSWD_ENC=$(grep mysql_root_password /etc/puppet/hieradata/$SERVER_NAME.yaml | sed 's/mysql_root_password: //g')
MYSQL_ROOT_PASSWD=$(sudo puppet crypt decrypt $MYSQL_ROOT_PASSWD_ENC)

# one time install; assuming default pihemr runtime environment
sudo apt-get install apache2
sudo a2enmod proxy_http

sudo cp ./etc.apache.sites-enabled.001-bahmni.conf /etc/apache2/sites-enabled/001-bahmni.conf
sudo rm /etc/apache2/sites-enabled/000-default.conf
sudo sed -i.bak "s/localhost/$SERVER_NAME/g" /etc/apache2/sites-enabled/001-bahmni.conf
sudo mv /var/www/html/index.html /var/www/html/index.html.old
sudo cp ./var.www.html-index.html /var/www/html

# load the initial DB
mysql -u root -p$MYSQL_ROOT_PASSWD <<EOF
create database openmrs_bahmni;
grant all on openmrs_bahmni.* to 'openmrs'@'localhost' identified by 'openmrs';
EOF
mysql -u root -p$MYSQL_ROOT_PASSWD openmrs_bahmni < ./openmrs-bahmni-mysqldump.sql

# tweak some config data
mysql -u root -p$MYSQL_ROOT_PASSWD openmrs_bahmni <<EOF
update global_property set property_value ='/home/tomcat7/.OpenMRS/patient_images' where property='emr.personImagesDirectory';
EOF

# deactivate any currently running OpenMRS/PIH-EMR instance
sudo service tomcat7 stop
cd /usr/local/tomcat7/webapps
sudo mv openmrs.war ../openmrs-pihemr.war
sudo mv openmrs ../openmrs-pihemr
cd /home/tomcat7/
sudo mv .OpenMRS .OpenMRS-pihemr

