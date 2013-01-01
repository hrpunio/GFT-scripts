#!/bin/bash
#
# GPX (or KML) file conversion to simplified KML (for subsequent upload to GoogleMaps
# Tomasz Przechlewski, 2012
#
# Maximum number of points for track:
STYLE=~/share/xml/gpxtimestamp.xsl
# KMLSTYLE=~/share/xml/kml2kml.xsl
KMLSTYLE=~/bin/kml2kml.pl
#
FORMAT="GPX"
COUNT=99
## Output file default name: 
NAME=`date +%Y%m%d_%H`;

USAGE="kml2kml [-max liczba] plik
  gdzie: 
  -format   GPX|KML (default: $FORMAT)
  -plik     KML or GPX file
  -max      Maximum number of points for track (default: $COUNT)
"

while test $# -gt 0; do
  case "$1" in

    -help|--help|-h) echo "$USAGE"; exit 0;;

    -format)  shift; FORMAT="$1";;
    -format*) FORMAT="`echo :$1 | sed 's/^:-format//'`";;
    -name)  shift; NAME="$1";;
    -name*) NAME="`echo :$1 | sed 's/^:-name//'`";;

    -max)  shift; COUNT="$1";;
    -max*) COUNT="`echo :$1 | sed 's/^:-max//'`";;
    *)   FILE="$1";;
  esac
  shift
done

if [ "$FILE" = "" ] ; then  echo "$USAGE" ; exit 1 ; fi

echo ":$FILE:"

if [ ! -f "$FILE" ] ; then  echo "$USAGE" ; exit 1
fi 

OUT_FILE="${FILE%.*}"

TMP_FILE=/tmp/${OUT_FILE}.kml.tmp


if [ "$FORMAT" = "GPX" ]  ; then

  echo "*** Converting $FILE to ${TMP_FILE} ..."

  if [ -f "$FILE" ] ; then
    gpsbabel -i gpx -f $FILE -x simplify,count=$COUNT  -o kml -F $TMP_FILE
  else
    echo "*** ERROR *** File $FILE not found.... ***"
    exit 
  fi
 else
 ###
 cp $FILE $TMP_FILE
fi

## KML -> Simplified KML (with Perl)
echo "*** [PERL] Converting $TMP_FILE to ${OUT_FILE}.kml with maximum $COUNT points..."
 
#echo "KML' Placemark name is: $NAME..."
#xsltproc --stringparam FileName "$NAME" -o ${OUT_FILE}.kml $KMLSTYLE $TMP_FILE
perl $KMLSTYLE  $TMP_FILE  > ${OUT_FILE}.kml


## Start/Stop time and date:
STARTTIME=`xsltproc --param Position '"First"' $STYLE $FILE`
STOPTIME=`xsltproc --param Position '"Last"' $STYLE $FILE`
DATE=`xsltproc --param Position '"First"' --param Mode '"Date"' $STYLE $FILE`

echo "*** TRACK SUMMARY:"
echo "*** Track date: $DATE ; time: $STARTTIME (start) ... $STOPTIME (stop)."
echo "<!-- @track_start_date: $DATE time_start: $STARTTIME time_stop: $STOPTIME -->" >> ${OUT_FILE}.kml

echo "*** Done..."
