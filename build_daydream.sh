#!/bin/bash

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

DEVICE="$1"
SYNC="$2"
THREADS="$3"
CLEAN="$4"

# Build Date/Version
VERSION=`date +%Y%m%d`


# Time of build startup
res1=$(date +%s.%N)

echo -e "${cya}Building ${bldcya} Project-DayDream Nightly-$VERSION ${txtrst}";

echo -e  ${bldblu}" DDDDDDD         AAA       YY     YY        DDDDDDD       RRRRRRRRR      EEEEEEEE          AAA           MM               MM "
echo -e  " DD    DD       AA  AA      YY   YY         DD    DD      RR       RR    EE               AA  AA         MMMM            MMMM"
echo -e  " DD     DD     AA    AA      YY YY          DD     DD     RR       RR    EE              AA    AA        MM  MM         MM MM"
echo -e  " DD      DD   AA      AA      YYY           DD      DD    RRRRRRRRR      EE             AA      AA       MM   MM       MM  MM"
echo -e  " DD      DD  AAAAAAAAAAAA     YYY           DD      DD    RRRR           EEEEEEEE      AAAAAAAAAAAA      MM    MM     MM   MM"
echo -e  " DD     DD  AA          AA    YYY           DD     DD     RR  RR         EE           AA          AA     MM     MM   MM    MM "
echo -e  " DD    DD  AA            AA   YYY           DD    DD      RR     RR      EE          AA            AA    MM      MM MM     MM"
echo -e  " DDDDDDD  AA              AA  YYY           DDDDDDD       RR       RR    EEEEEEEEE  AA              AA   MM       MM       MM" 


# sync with latest sources
echo -e ""
if [ "$SYNC" == "sync" ]
then
   echo -e "${bldblu}Syncing latest Project-DayDream sources ${txtrst}"
   repo sync -j"$THREADS"
   echo -e ""
fi

# setup environment
if [ "$CLEAN" == "clean" ]
then
   echo -e "${bldblu}Cleaning up out folder ${txtrst}"
   make clobber;
else
  echo -e "${bldblu}Skipping out folder cleanup ${txtrst}"
fi


# setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh

# lunch device
echo -e ""
echo -e "${bldblu}Lunching your device ${txtrst}"
lunch "daydream_$DEVICE-userdebug";

echo -e ""
echo -e "${bldblu}Starting Project-DayDream build for $DEVICE ${txtrst}"

# start compilation
brunch "daydream_$DEVICE-userdebug" -j"$THREADS";
echo -e ""

# finished? get elapsed time
res2=$(date +%s.%N)
echo "Congratulations! You finished building Project-DayDream Nightly!"
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
