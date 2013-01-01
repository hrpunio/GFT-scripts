#!/bin/bash
# 
# Upload KML to MYTRACKS_TABLE_ID (GoogleFusionTables) 
# Simplified KML is expected (generated with kml2kml.sh script)
# Tomasz Przechlewski, 2012
#
# Idea of the script stole from:
# ------------------------------
# Copyright 2011 Google Inc. All Rights Reserved.
# Author: arl@google.com (Anno Langen)
# http://code.google.com/intl/pl/apis/fusiontables/docs/samples/curl.html
# 
MYTRACKS_TABLE_ID="2590817"
KML_FILE="${GPX_FILE%.*}".kml

## Get date/start time/stop time from comment inserted by kml2kml.sh 
STARTTIME=`cat $KML_FILE | awk '/@track_start_date/ {print $7}'`
STOPTIME=`cat $KML_FILE | awk '/@track_start_date/ {print $5}'`
DATE=`cat $KML_FILE | awk '/@track_start_date/ {print $3}'`

if [ $STARTTIME = "" ] ; then echo "*** Error *** Something wrong! Invalid STARTTIME " ; exit ; fi
if [ ! -f $KML_FILE ] ; then echo "*** Error *** No KML file: $KML_FILE" ; exit ; fi

function ClientLogin() {
  ##read -p 'Email> ' email
  ##read -p 'Password> ' -s password
  password='G@baPent1n;'
  email='looseheadprop1@gmail.com'
  local service=$1
  curl -s -d Email=$email -d Passwd=$password -d service=$service https://www.google.com/accounts/ClientLogin | tr ' ' \n | grep Auth= | sed -e 's/Auth=//'
}

function FusionTableQuery() {
  local sql=$1
  curl -L -s -H "Authorization: GoogleLogin auth=$(ClientLogin fusiontables)" \
      --data-urlencode sql="$sql" https://www.google.com/fusiontables/api/query
}

## All we need is a track cut from KML file:
TRACK=`perl -e 'undef $/; $t = <>; $t =~ m/(<coordinates>.*<\/coordinates>)/s; $t = $1; $t =~ s/[ \t\n]+/ /gm; print $t;' $KML_FILE`
TRACK="<LineString>$TRACK</LineString>"

##FusionTableQuery "SELECT * FROM 197026"
## Dziala
##FusionTableQuery "SHOW TABLES"
##FusionTableQuery "DESCRIBE 2590817"
FusionTableQuery "INSERT INTO $MYTRACKS_TABLE_ID (Date, Start, Stop, Location, Description) VALUES ('$DATE', '$STARTTIME', '$STOPTIME', '$TRACK', '') "

## end ##
