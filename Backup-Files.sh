#!/bin/bash
switches="-av --delete-after --no-links --progress"
#Change backuplocation to prefered location
backuplocation="/media/backup/filebackup"

rsync $switches /opt/letsencrypt $backuplocation
rsync $switches /etc $backuplocation
rsync $switches /home $backuplocation

fi
