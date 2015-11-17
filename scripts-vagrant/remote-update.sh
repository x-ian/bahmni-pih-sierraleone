
BAHMNI_DIST_DIR=`pwd`

sudo service tomcat7 stop

cd /usr/local/tomcat7/webapps

# deactivate current openmrs/pih-emr, already done through install
#sudo mv openmrs.war ../openmrs-pihemr.war
#sudo mv openmrs ../openmrs-pihemr

# save configs
cp /usr/local/tomcat7/webapps/bahmnireports/WEB-INF/classes/application.properties /tmp

sudo tar xzf $BAHMNI_DIST_DIR/bahmnireports.tgz
sudo cp $BAHMNI_DIST_DIR/openmrs-webapp-1.11.4.war openmrs.war
sudo mv /tmp/application.properties /usr/local/tomcat7/webapps/bahmnireports/WEB-INF/classes/application.properties
sudo chown -R tomcat7:tomcat7 bahmnireports/ openmrs.war

echo "edit /usr/local/tomcat7/webapps/bahmnireports/WEB-INF/classes/application.properties and adjust as needed"

cd /home/tomcat7/

# deactivate current openmrs/pih-emr, already done through install
#sudo mv .OpenMRS .OpenMRS-pihemr

cp /home/tomcat7/.OpenMRS/openmrs-runtime.properties /tmp

sudo tar xzf $BAHMNI_DIST_DIR/dot.OpenMRS.tgz 
sudo mv dot.OpenMRS/ .OpenMRS
sudo mkdir .OpenMRS/patient_images
sudo mv /tmp/openmrs-runtime.properties /home/tomcat7/.OpenMRS/openmrs-runtime.properties
sudo chown -R tomcat7:tomcat7 .OpenMRS/
sudo sed -i.bak "s/root/home\/tomcat7/g" /home/tomcat7/.OpenMRS/bahmnicore.properties

echo "edit /home/tomcat7/.OpenMRS/openmrs-runtime.properties and change connection.* as needed"

sudo service tomcat7 start

cd /var/www
sudo tar xzf $BAHMNI_DIST_DIR/default-config.tgz
sudo mv default-config bahmni_config
sudo tar xzf $BAHMNI_DIST_DIR/openmrs-module-bahmniapps.ui.app.tgz 
sudo mv app bahmniapps
#sudo chown -R bahmniapps bahmni_config

sudo service apache2 restart

