#!/bin/bash

TOMCAT_DIR=~/apache-tomcat-7.0.65

export CATALINA_OPTS=" -Xms1536m -Xmx1536m -XX:NewSize=256m -XX:MaxNewSize=256m -XX:PermSize=256m  -XX:MaxPermSize=256m"

$TOMCAT_DIR/bin/catalina.sh start
