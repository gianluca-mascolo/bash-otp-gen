#!/bin/bash
setterm -cursor off
clear
Backspace="$(echo -e '\x7f')"
search=""
SEL=0
while /bin/true; do {
echo -e "\033[1;1HSearch code: * $search *\033[K"

tput ed
if ( [ "x$search" != "x" ] ); then
 SEL="$(jq -r -M .[].name otpconf.json | grep -i "$search" | head -5 | wc -l)";
 if ( [ $SEL -eq 1 ] ); then
  FIND="$(jq -r -M .[].name otpconf.json | grep -i "$search")"
  echo "$FIND"
  cat otpconf.json   | jq -r -M ".[] | select(.name == \"$FIND\") | .generator"
   else
  jq -r -M .[].name otpconf.json | grep -i "$search" | head -5 | nl -ba -w2 -s ") ";
 fi
else
 SEL=0
fi
echo "# $SEL"
read -s -N1 -t1 TASTO
[ "$TASTO" = "$Backspace" ] && search=""
[ "x$TASTO" = "x" ] && TASTO=""
#echo -n "$TASTO" | sed -re "s/(.).*/\1/" | egrep -ixq "[[:alnum:]]"
if ( echo "$TASTO" | head -1 | egrep -ixq "([[:alnum:]]| )" ); then
 search="$search$TASTO";
else
 #clear
 #echo "$TASTO" | hexdump -C
 #echo ""
 #echo "" 
 #echo "## $TASTO ##"
 #sleep 1
 read -s -t 0.1 TASTO
 TASTO=""
fi
tput ed

}

done
setterm -cursor on
