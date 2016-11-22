#!/bin/bash
STOR_SRV=storage.example.com
STOR_PATH=/home/user/path
DATE=`date +%Y-%m-%d-%H.%M.%S`
echo "Dumping blue_hydra.db to blue_hydra.csv"
sqlite3 -header -csv /opt/pwnix/data/blue_hydra/blue_hydra.db "select * from blue_hydra_devices;" > /var/log/pwnix/blue_hydra-$DATE.csv
cp /opt/pwnix/data/blue_hydra/blue_hydra.db /var/log/pwnix/blue_hydra-$DATE.db
rsync -avz /var/log/pwnix/blue_hydra* $STOR_SRV:$STOR_PATH
echo "Done!"
