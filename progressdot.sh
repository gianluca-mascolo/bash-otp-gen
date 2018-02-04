#!/bin/bash

a=1234
x=1
y=2
clear

pbar[5]=" !-     | "
pbar[4]=" |--    | "
pbar[3]=" |---   | "
pbar[2]=" |----  | "
pbar[1]=" |----- | "
pbar[0]=" |------| "

       #++123456++
#BORDER=" ~~~~~~~~ "
NAME="AWS account 1"
#echo "$BORDER"
echo "[ 123456 ] $NAME"
echo "${pbar[0]}"
#echo "Name: $NAME"
for ((n=1;n<6;n++)); do {
sleep 1
echo -e "\033[1;1H[ 12345$n ] $NAME"
echo -e "${pbar[$n]}"
#echo "Name: $NAME"
#echo "| 123456 |${dot[$n]}"
}
done
