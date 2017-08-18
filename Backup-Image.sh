#!/bin/bash
# Backup OS to Network Share

# Checks for app dependencies
type pigz >/dev/null 2>&1 || { 
  echo >&2 "I require PIGZ but it's not installed.  Aborting."; exit 1; 
}

# Create a filename with datestamp for our current backup.
# Change /media/backup directory to location you want to back up. In this 
# case I used a mount of network share.
ofile="/media/backup/Backup_$(date +%b-%d-%y)"

# Create final filename, with suffix
ofilefinal=$ofile.gz

# Begin the backup process, should take about 1 hour from 8Gb SD card to HDD/share
echo -e "\e[93mBacking up SD card to server as "$ofilefinal
echo -e "\e[93mThis will take many hours. Please wait..."
pv /dev/sda | pigz --fast > $ofile
# Collect result of backup procedure
result=$?

# If command has completed successfully, delete previous backups and exit
if [ $result = 0 ]; then
    echo -e "\e[92mSuccessful backup, previous backup files will be deleted."
    rm -f /media/backup/Backup_*.gz
    mv $ofile $ofilefinal
    exit 0
# Else remove attempted backup file
else
   echo -e "\e[91mBackup failed! Previous backup files untouched."
   echo -e "\e[91mPlease check status of server"
   rm -f $ofile
   exit 1
fi
