#!/bin/bash

# pushes BAHMNI_DIST to remote server with rsync
# reguires a local ./temp directory and a matching remote bahmni-dist dir

DIST_DIR=./temp
#DEST_DIR=cneumann@padi.pih-emr.org:bahmni-dist
DEST_DIR=cneumann@192.168.1.182:bahmni-dist

rsync -av --del --stats $DIST_DIR/ $DEST_DIR/

