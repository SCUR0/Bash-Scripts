#!/bin/bash

#String colors
yellow='\033[1;33m'
red='\033[0;31m'
green='\033[0;32m'

# Backup OS to Network Share

# Checks for app dependencies
type pigz >/dev/null 2>&1 || { 
  echo >&2 "PIGZ is required for script.  Aborting."
  exit 1
}
# Checks for app dependencies
type pv >/dev/null 2>&1 || { 
  echo >&2 "PV is required for script.  Aborting."
  exit 1
}

# Create a filename with datestamp for our current backup.
# Change /media/backup directory to location you want to back up. In this 
# case I used a mount of network share.
file="/media/backup/Backup_$(date +%b-%d-%y).gz"

# Begin the backup process
echo -e "${yellow}Backing up SD card to server as "$file
echo -e "${yellow}This will take some time. Please wait..."
pv /dev/mmcblk0 | pigz --fast > $file
# Collect result of backup procedure
result=$?

# If command has completed successfully, delete previous backups and exit
if [ $result = 0 ]; then
    echo -e "${green}Backup complete"
    exit 0
# Else remove attempted backup file
else
   echo -e "${red}Backup failed."
   echo -e "${yellow}Please check status of mount."
   rm -f $file
   exit 1
fi
