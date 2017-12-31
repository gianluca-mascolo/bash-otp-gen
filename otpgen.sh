#!/bin/bash

# Do you like it? Follow my telegram channel: http://t.me/linuxcheatsheet

#    GPLv3 or Later
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Path to configuration file
OtpConf="otpconf.json"

# To evaluate script dependencies before run it
function check_depend {
  hash "$1" 2> /dev/null
  if ( [ $? -ne 0 ] ); then echo "${1}: Not found"; exit 1; else echo "${1}: OK"; return 0; fi
}

# Sanity Checks

check_depend jq
check_depend oathtool
check_depend date

# Check for configuration file presence
if ( ! [ -f "$OtpConf" ] ); then echo "${OtpConf}: Missing or unreadable file"; exit 1; fi
# Check is configuration is a valid JSON
jq . "$OtpConf" 2> /dev/null &> /dev/null
if ( [ $? -ne 0 ] ); then echo "${OtpConf}: Bad Json"; exit 1; fi
# Check JSON array length
ConfLen="$(jq '. | length'  "$OtpConf")"
echo "$ConfLen" | egrep -q "^[1-9]+[0-9]*$"
if ( [ $? -ne 0 ] ); then echo "${OtpConf}: Can't find a valid array"; exit 1; fi

# Main program

# Get Otp Name, check for validity
function get_otp_name {
  local TryOtpName
  TryOtpName="$(jq -r -M ".[$1].name" $OtpConf)"
  echo "$TryOtpName" | egrep -q "^null$"
  if ( [ $? -ne 0 ] ); then echo "$TryOtpName"; return 0; else echo "$OtpConf: Can't get Otp Name"; return 1; fi
}

# Get Otp Generator, check for validity
function get_otp_generator {
  local TryOtpGenerator
  TryOtpGenerator="$(jq -r -M ".[$1].generator" $OtpConf)"
  echo "$TryOtpGenerator" | egrep -q "^null$"
  if ( [ $? -ne 0 ] ); then echo "$TryOtpGenerator"; return 0; else echo "$OtpConf: Can't get Otp Generator"; return 1; fi
}

# Generate a progress bar
function progress_bar {
  local Now
  local BarLen
  local Bar
  local i
  Now="$(date +%s)"
  BarLen="$(( ((29 - (Now % 30)) /3)  ))"
  unset Bar
  for ((i=0;i<BarLen;i++)); do Bar="${Bar}#"; done
  for ((i=BarLen;i<10;i++)); do Bar="${Bar}_"; done
  echo "$Bar"
  return 0
}


clear
while /bin/true; do {
  echo "+--------------------+"
  echo "| Bash Otp Generator |"
  echo "+--------------------+"
  echo ""
  ProgressBar="$(progress_bar)"
  echo -e "  Time Left \t  Code  \t Name\n"
  for (( n=0; n<$ConfLen;n++)); do {
    OtpName="$(get_otp_name $n)" || ( echo "$OtpName" ; exit 1 )
    OtpGenerator="$(get_otp_generator $n)" || ( echo "$OtpGenerator" ; exit 1 )
    OtpCode="$(oathtool --totp -b "$OtpGenerator")" || ( echo "${OtpName}: Invalid Code" ; exit 1 )
    echo -e "[$ProgressBar]\t[$OtpCode]\t$OtpName"
  }
  done
  echo -e "\nGenerated at $(date)"
  echo -e "\nPress CTRL-C to exit"
  sleep 1
  clear
}
done

exit 0
