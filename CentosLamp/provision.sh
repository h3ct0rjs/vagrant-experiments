#!/bin/bash
#Provision a MPI Cluster using vagrant. 
#Bash Script configuration
#hfjimenez@utp.edu.co
BLACK='\033[0;30m'        # Black
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'       # Yellow
BLUE='\033[0;34m'         # Blue
PURPLE='\033[0;35m'       # Purple
CYAN='\033[0;36m'         # Cyan
WHITE='\033[0;37m'        # White
NC='\033[0m' 		  # No Color

main() {
	echo -e "${CYAN}LAMP Under Centos7${NC}"
	echo -e "${WHITE}Provision.sh Started${NC}"
	update_go
	tools_go
	#change_indexwww
}	

update_go() {
	# Update the server
	echo -e "[${WHITE}Ok${NC}] Updating package and distribution "
	yum update
	#echo -e "${WHITE}"
	# yum -y upgrade  #We're going to comment this, it speed up our worker creation :) 
	echo -e "${NC}"
}

autoremove_go() {
	echo -e "[${WHITE}Ok${NC}] Cleaning unnecesary packages"
	echo -e "${WHITE}"
	package-cleanup -q --leaves | xargs -l1 yum -y remove 
	echo -e "${NC}"
}

tools_go() {
	# Install basic tools
	echo -e "[${WHITE}Ok${NC}] Installing all required packages"
	sudo systemctl stop firewalld
	sudo yum install net-tools -y
	echo -e "[${WHITE}Ok${NC}] Apache" 
	sudo yum install httpd -y
	echo -e "[${WHITE}Ok${NC}] Starting service, and persistence under reboot"
	sudo systemctl start httpd.service
	sudo systemctl enable httpd.service
	echo -e "[${WHITE}Ok${NC}] PHP"
	sudo yum install php php-mysql -y
	echo -e "[${WHITE}Ok${NC}] MariaDB"
	sudo yum install mariadb-server mariadb -y

}

change_indexwww(){
      #
      echo -e "[${WHITE}Ok${NC}] Creating Test Page"
      if [[ ! -e /vagrant/index.php ]]; then
			echo -e "[${RED}Err${NC}] Unable to find Test Page !\n"
	  else
		 cp /vagrant/index.php /var/www/html/index.php
      fi

}

main
exit 0