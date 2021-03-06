#!/bin/bash
# This script is to upload Kismet netxml files to wigle.net and transfer them to a folder for long term backup.
#
# Wigle.net credentials
USER="USER"
AUTH="auth=USER:KEY"
#
#
# Kismet temp log location
CAPDIR="/home/pi/KismetTemp/"
# Long term storage and sync folder
STODIR="/home/pi/Kismet/"
#
PCAPS="/home/pi/pcaps/"
#
#
#
# Are we online and able to pull from wigle.net?
wget --timeout=15 --spider https://wigle.net/uploads
if [ $? -eq 0 ]
then
    mkdir "$CAPDIR"handshake/
    mkdir "$CAPDIR"pcap/
    ls -l $CAPDIR | grep -o Kismet-.*.pcapdump$ | awk '{print "wpaclean '$CAPDIR'handshake/"$1".hs.cap '$CAPDIR'"$1""}' | xargs -0 bash -c
    find "$CAPDIR"handshake/ -type f -size -2b -delete
    ls -l "$CAPDIR"handshake/ | grep -o Kismet-.*.pcapdump.hs.cap$ | awk '{print "cap2hccap '$CAPDIR'handshake/"$1" '$CAPDIR'handshake/"$1".hccap"}' | xargs -0 bash -c
    # Move pcaps?
	mkdir "$PCAPS"
    mv "$CAPDIR"Kismet-*.pcapdump "$PCAPS"
    # Handshake rip complete
    echo "Done with handshakes!"
    # Copy temp log files to long term storage and sync
    cp -R "$CAPDIR"* $STODIR
    # Generate list of files in the temp folder and start uploading to wigle.net as $USER
    ls -l $CAPDIR | grep -o Kismet-.*.netxml$ | awk '{print "curl --cookie '$AUTH' --form stumblefile=@'$CAPDIR'"$1" --form Send=Send --form observer='$USER' https://wigle.net/upload > /dev/null 2>&1"}' | xargs -0 bash -c
    rm -R "$CAPDIR"*
    echo "Log Dump Completed!"
    # Restart Kismet now
    killall kismet_server
else
   echo "Unable to reach wigle.net"
fi
