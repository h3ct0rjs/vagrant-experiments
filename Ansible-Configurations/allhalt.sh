#!/bin/bash
#Bash Script configuration
#feedback:hfjimenez@utp.edu.co

BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red

for i in `vagrant status |grep runnin|awk '{print $1}'`
do 
	echo -e "${RED} Halting $i"
	vagrant halt $i;
done

