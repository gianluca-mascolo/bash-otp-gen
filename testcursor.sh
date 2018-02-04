#!/bin/bash



a=1234

# \033[s save cursor position
clear
echo "method 1"
echo "+------+"
echo -e "\033[s| $a |"
echo "+------+"

# \033[s restore cursor position
for ((n=a; n<a+10;n++)); do {
sleep 1
echo -e "\033[u| $n |"
}
done

echo "+--**--+"

for ((n=0;n<5;n++)); do echo -n "."; sleep 1;  done


# upper left pixel has coordinates x,y 1,1
# \033[3;1 cursor in  position line 3 column 1

a=1234
clear
echo "method 2"
echo "+------+"
echo -e "\033[3;1H| $a |"
echo "+------+"
for ((n=a; n<a+10;n++)); do {
sleep 1
echo -e "\033[3;1H| $n |"
}
done
