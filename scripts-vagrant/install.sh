#!/bin/bash

# needs to match puppet hieradata .yaml file
SERVER_NAME=wellbody.pih-emr.org
DIST_DIR=~/bahmni-dist
TOMCAT_DIR=~/apache-tomcat-7.0.65

# grab some configs from puppet config
MYSQL_ROOT_PASSWD_ENC=$(grep mysql_root_password /etc/puppet/hieradata/$SERVER_NAME.yaml | sed 's/mysql_root_password: //g')
MYSQL_ROOT_PASSWD=$(sudo puppet crypt decrypt $MYSQL_ROOT_PASSWD_ENC)

# one time install; assuming default pihemr runtime environment
apt-get install apache2
a2enmod proxy_http

cp $DIST_DIR/etc.apache2.sites-enabled.001-bahmni.conf /etc/apache2/sites-enabled/001-bahmni.conf
rm /etc/apache2/sites-enabled/000-default.conf
sed -i.bak "s/localhost/$SERVER_NAME/g" /etc/apache2/sites-enabled/001-bahmni.conf
mv /var/www/html/index.html /var/www/html/index.html.old
cp $DIST_DIR/var.www.html-index.html /var/www/html
sed -i.bak "s/localhost/$SERVER_NAME/g" /var/www/html/index.html

# load the initial DB
mysql -u root -p$MYSQL_ROOT_PASSWD <<EOF
create database openmrs_bahmni;
grant all on openmrs_bahmni.* to 'openmrs'@'localhost' identified by 'openmrs';
EOF
mysql -u root -p$MYSQL_ROOT_PASSWD openmrs_bahmni < $DIST_DIR/openmrs.mysqldump.sql

# tweak some config data
mysql -u root -p$MYSQL_ROOT_PASSWD openmrs_bahmni <<EOF
update global_property set property_value ='/home/tomcat7/.OpenMRS/patient_images' where property='emr.personImagesDirectory';
EOF

# deactivate any currently running OpenMRS/PIH-EMR instance
wget http://www.eu.apache.org/dist/tomcat/tomcat-7/v7.0.65/bin/apache-tomcat-7.0.65.tar.gz
cd ~
tar xzf apache-tomcat-7.0.65.tar.gz
mkdir $TOMCAT_DIR/webapps-deactivated
mv $TOMCAT_DIR/webapps/docs $TOMCAT_DIR/webapps-deactivated
mv $TOMCAT_DIR/webapps/examples $TOMCAT_DIR/webapps-deactivated
mv $TOMCAT_DIR/webapps/host-manager $TOMCAT_DIR/webapps-deactivated
mv $TOMCAT_DIR/webapps/manager $TOMCAT_DIR/webapps-deactivated

