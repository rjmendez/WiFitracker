#!/bin/bash
DATE=`date -Iseconds`
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin
# kill sdr
sudo killall rtl_tcp
# kill rtlamr
sudo killall rtlamr

find /home/pi/ERT/ -maxdepth 1 -type f -size -2c -delete
rsync -avz ERT/rtlamr* pi@172.16.42.245:/home/pi/Kismet/ERT
rsync -avz /home/pi/zbwalk pi@172.16.42.245:/home/pi/Kismet/ERT
mv /home/pi/ERT/rtlamr* /home/pi/ERTrsync/
mkdir /home/pi/ERT/

# start sdr
rtl_tcp &> /dev/null &
#rtl_tcp &> /home/pi/ERT/rtl_tcp$DATE.log &
# sleep 5 seconds
sleep 5
# start rtlamr and add gps location
rtlamr -format=csv -msgtype=scm -quiet=true | while IFS= read -r line; do echo "$line,$(gpspipe -w -n 10 | grep -o -m 1 -E '.lat.{0,15}|.lon.{0,15}|.alt.{0,14}' | sed 's/"lat"://' | sed 's/,//' | sed 's/"lon"://' | sed 's/,//' | sed 's/"alt"://' | sed 's/,//' | sed 's/\"//' | sed 's/eps//' | sed 's/ep//' | sed 's/s//' | sed 's/x//' | tr  '\n' ,)"; done > /home/pi/ERT/rtlamr$DATE.log &
