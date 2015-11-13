#!/bin/bash
set -e -x
rm -rf *

BASE_URL=http://172.18.2.11:8153
ARTIFACTS_Build_Name=Latest
Config_Build_Name=Latest
IMPLEMENTATION_NAME=default
BRANCH=master
GO_USER=guest
GO_PWD=p@ssw0rd

echo "CI SERVER: $BASE_URL"

echo "Downloading openmrs artifacts"
echo "--------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_artifacts_$BRANCH/$ARTIFACTS_Build_Name/CollectArtefactsStage/Latest/defaultJob/deployables/mrs.zip && unzip -qo mrs.zip && rm mrs.zip && mv mrs/* . && rm -rf mrs


echo "Downloading openelis artifacts"
echo "-------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge  $BASE_URL/go/files/Bahmni_artifacts_$BRANCH/$ARTIFACTS_Build_Name/CollectArtefactsStage/Latest/defaultJob/deployables/elis.zip && unzip -qo elis.zip && rm elis.zip && mv elis/* . && rm -rf elis

echo "Downloading reference_data artifacts"
echo "-------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge $BASE_URL/go/files/Bahmni_artifacts_$BRANCH/$ARTIFACTS_Build_Name/CollectArtefactsStage/Latest/defaultJob/deployables/referencedata.zip && unzip -qo referencedata.zip && rm referencedata.zip && mv referencedata/* . && rm -rf referencedata

echo "Downloading Environment artifacts"
echo "-------------------------------------"
wget --user=$GO_USER --password=$GO_PWD --auth-no-challenge $BASE_URL/go/files/Bahmni_artifacts_$BRANCH/$ARTIFACTS_Build_Name/CollectArtefactsStage/Latest/defaultJob/deployables/environment.zip && unzip -qo environment.zip && rm environment.zip && mv environment/* . && rm -rf environment



rm -f *_md5.checksum