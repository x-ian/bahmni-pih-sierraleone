#!/bin/bash

TOMCAT_DIR=/home/cneumann/apache-tomcat-7.0.65
BAHMNI_DIST_DIR=~/bahmni-dist

#sudo service tomcat7 stop

cd $TOMCAT_DIR/webapps

# save configs
cp $TOMCAT_DIR/webapps/bahmnireports/WEB-INF/classes/application.properties /tmp

tar xzf $BAHMNI_DIST_DIR/bahmnireports.webapp.tgz
tar xzf $BAHMNI_DIST_DIR/openmrs.webapp.tgz
mv /tmp/application.properties $TOMCAT_DIR/webapps/bahmnireports/WEB-INF/classes/application.properties

echo "edit $TOMCAT_DIR/webapps/bahmnireports/WEB-INF/classes/application.properties and adjust as needed"

cd ~

cp .OpenMRS/openmrs-runtime.properties /tmp

tar xzf $BAHMNI_DIST_DIR/dot.OpenMRS.tgz 
mv dot.OpenMRS/ .OpenMRS
mkdir .OpenMRS/patient_images
mv /tmp/openmrs-runtime.properties /home/tomcat7/.OpenMRS/openmrs-runtime.properties
#sudo sed -i.bak "s/root/home\/tomcat7/g" /home/tomcat7/.OpenMRS/bahmnicore.properties

echo "edit /home/tomcat7/.OpenMRS/openmrs-runtime.properties and change connection.* as needed"

#sudo service tomcat7 start

cd /var/www
tar xzf $BAHMNI_DIST_DIR/bahmni_config.tgz
tar xzf $BAHMNI_DIST_DIR/bahmniapps.tgz 
#sudo chown -R bahmniapps bahmni_config

#sudo service apache2 restart

