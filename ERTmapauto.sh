#!/bin/bash
ERTDIR="Kismet/ERT/"
CSVCONV="python test_csvtokml.py"
# clean up
find "$ERTDIR" -maxdepth 1 -type f -size -112c -delete
mkdir "$ERTDIR"lts/
cp "$ERTDIR"rtlamr*.log "$ERTDIR"lts/
# Convert to kml
ls -l "$ERTDIR" | grep -o rtlamr.*.log$ | awk '{print "python test_csvtokml.py '$ERTDIR'"$1""}' | xargs -0 bash -c
mkdir "$ERTDIR"map/
cp "$ERTDIR"rtlamr*.kml "$ERTDIR"map/
find "$ERTDIR"map/ -maxdepth 1 -type f -size -182c -delete
rm -f "$ERTDIR"rtlamr*
# Done
