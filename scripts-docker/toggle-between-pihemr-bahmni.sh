#!/bin/bash

sudo service tomcat7 stop

cd /home/tomcat7

if [ -d .OpenMRS-bahmni ]; then
  sudo mv .OpenMRS .OpenMRS-pihemr
  sudo mv .OpenMRS-bahmni .OpenMRS
elif [ -d .OpenMRS-pihemr ]; then
  sudo mv .OpenMRS .OpenMRS-bahmni
  sudo mv .OpenMRS-pihemr .OpenMRS
else
  echo "Unknown state in /home/tomcat7"
fi

cd /usr/local/tomcat7/webapps

if [ -d ../openmrs-bahmni ]; then
  sudo mv openmrs.war ../openmrs-pihemr.war
  sudo mv openmrs ../openmrs-pihemr
  sudo mv ../openmrs-bahmni.war openmrs.war
  sudo mv ../openmrs-bahmni openmrs
  sudo mv ../bahmnireports .
elif [ -d .OpenMRS-pihemr ]; then
  sudo mv openmrs.war ../openmrs-bahmni.war
  sudo mv openmrs ../openmrs-bahmni
  sudo mv bahmnireports ..
  sudo mv ../openmrs-pihemr.war openmrs.war
  sudo mv ../openmrs-pihemr openmrs
else
  echo "Unknown state in /usr/local/tomcat7/webapps"
fi

# get rid of any temp files
sudo rm -rf ../work/Catalina/localhost/openmrs*

sudo service tomcat7 start