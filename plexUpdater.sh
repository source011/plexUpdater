#!/bin/bash
#========== V A R S ===============
RED='\033[0;31m'
NC='\033[0m' # No Color
PLEXTOKEN="ADD-PLEX-TOKEN-HERE!" # How to find your plex token -> (https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/)
HOMEFOLDER="/home/YOUR-USERNAME" # Change this in order to get the log working (No trailing slash)
#==================================
if [ "$EUID" -ne 0 ]
  then echo ">>> DID YOU FORGET SUDO? ;)"
  exit
fi
printf "${RED}==========${NC} Plex Upgrade Script ${RED}==========${NC}\n"
printf "${RED}        ${NC} -created by source011- ${RED}        ${NC}\n"
printf " \n"
printf "        checking latest version ...\n"
printf " \n"
LATESTVERSION=$(curl -s -L https://forums.plex.tv/t/plex-media-server/30447/10000 | grep '<p><strong>Plex Media Server ' | grep -v "Plex Pass" | tail -1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")
printf "        latest version is: $LATESTVERSION \n"
CURRENTVERSION=$(ps -ef | grep plex | grep server-version | tail -1 | egrep -o "([0-9]{1,}\.)+[0-9]{1,}")
printf "        installed version is: $CURRENTVERSION \n"
printf " \n"
printf " \n"
if [ $LATESTVERSION \> $CURRENTVERSION ];
then
printf "        downloading latest version ...\n"
wget -q -O plexmediaserver-$LATESTVERSION.rpm "https://plex.tv/downloads/latest/5?channel=8&build=linux-x86_64&distro=redhat&X-Plex-Token=$PLEXTOKEN" 2>&1 >/dev/null
printf " \n"
printf "        stopping plex service ...\n"
systemctl stop plexmediaserver.service 2>&1 >/dev/null
printf " \n"
printf "        installing latest version ...\n"
dnf install -y plexmediaserver-$LATESTVERSION.rpm 2>&1 >/dev/null
printf " \n"
printf "        starting plex service ...\n"
systemctl start plexmediaserver.service 2>&1 >/dev/null
printf " \n"
printf "        deleting installer ...\n"
rm -f plexmediaserver-$LATESTVERSION.rpm 2>&1 >/dev/null
printf " \n"
printf " \n"
printf "        PLEX INSTALLED SUCCESSFULLY! ...\n"
printf " \n"
TIMESTAMP=`date +%Y-%m-%d_%H:%M:%S`
printf "[$TIMESTAMP] Updated Plex from $CURRENTVERSION to $LATESTVERSION!\n" >> $HOMEFOLDER/plexUpdater.log
else
printf "        latest version is installed, nothing to do ...\n"
TIMESTAMP=`date +%Y-%m-%d_%H:%M:%S`
printf "[$TIMESTAMP] nothing todo...\n" >> $HOMEFOLDER/plexUpdater.log
fi;
printf "${RED}==========${NC} Plex Upgrade Script ${RED}==========${NC}\n"
