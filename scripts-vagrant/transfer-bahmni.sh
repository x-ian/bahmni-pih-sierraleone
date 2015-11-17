#!/bin/bash

DIST_DIR=./temp
#DEST_DIR=cneumann@padi.pih-emr.org:bahmni-dist
DEST_DIR=cneumann@192.168.1.182:bahmni-dist

rsync -av --del --stats $DIST_DIR/ $DEST_DIR/

