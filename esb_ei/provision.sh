#!/bin/bash
#Provision a Enterprise Integrator using vagrant. 
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
	echo -e "${CYAN}Enterprise Integrator Centos7${NC}"
	echo -e "${WHITE}Provision.sh Started${NC}"
	update_go
	tools_go
	#change_indexwww
}	

update_go() {
	# Update the server
	echo -e "[${GREEN}Ok${NC}] Updating package and distribution "
	yum update
	#echo -e "${WHITE}"
	echo -e "[${GREEN}Ok${NC}] Install epel repositories"
	yum install epel-release -y
	# yum -y upgrade  #We're going to comment this, it speed up our worker creation :) 
	echo -e "${NC}"

}


attach_hard_drive(){
	echo -e "[${GREEN}Ok${NC}] Ataching Secondary Hard Drive"
	sudo lsblk
	echo -e "[${GREEN}Ok${NC}] Formating Secondary Hard Drive"
	mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
	echo -e "[${GREEN}Ok${NC}] Creating mount folder point"
	sudo mkdir -p /wso2
	sudo cp /etc/fstab /etc/fstab.backup
	echo -e "[${GREEN}Ok${NC}] Mounted, Creating persistent configuration"
	echo UUID=`sudo blkid -s UUID -o value /dev/sdb` /wso2 ext4 discard,defaults,nofail  2 | sudo tee -a /etc/fstab
	echo -e "[${RED}Ok${NC}] Verifying fstab file"
	sudo cat /etc/fstab
	mount 
	fdisk -l
}

tools_go() {
	# Install basic tools and create user.
	echo -e "[${GREEN}Ok${NC}] Installing all required packages"
	sudo yum install net-tools glances htop unzip vim -y
	echo -e "[${GREEN}Ok${NC}] Wget and Curl package"
	sudo yum install wget curl -y
	echo -e "[${GREEN}Ok${NC}] Adding wso2 User"
	sudo adduser wso2
	echo -e "[${GREEN}Ok${NC}] Install Java OpenJdk Enviroment"
	sudo  yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel -y
	echo -e "[${GREEN}Ok${NC}] Installing Java home for all users"
	data = $(alternatives --display java |grep best |awk '{print $5}'|cut -d '/' -f1-5)
	echo "export JAVA_HOME=${data}">>/etc/profile
	echo "export PATH=\$PATH:\$JAVA_HOME/bin">>/etc/profile
	echo -e "[${GREEN}Ok${NC}] Downloading wso2 Enterprise integrator."
	wget https://github.com/wso2/product-ei/releases/download/v6.4.0-m6/wso2ei-6.4.0-m6.zip -O /home/wso2/wsoei-6.4.zip
	echo -e "[${GREEN}Ok${NC}] Applying Permissions."
	chown wso2:wso2 /home/wso2/wsoei-6.4.zip
	
	echo -e "[${GREEN}Ok${NC}]  Login with your wso2 and start the proper configuration ."
	echo "PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\]\[\e[1;37m\]'">>/home/wso2/.bashrc
	attach_hard_drive
	mv /home/wso2/wsoei-6.4.zip  /wso2
}




main
exit 0