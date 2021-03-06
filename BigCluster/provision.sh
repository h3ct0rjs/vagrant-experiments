#!/bin/bash
#Provision a MPI Cluster using vagrant. 
#Bash Script configuration

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
	repositories_go
	update_go
	tools_go
	autoremove_go
	hostnames_go
	sshkeys_copy
	nfs_folder
}	

repositories_go() {
	echo -e "${CYAN}OpenMP and MPI CLUSTER, Sirius 2018${NC}"
	echo -e "${WHITE}Provision.sh Started${NC}"
}

update_go() {
	# Update the server
	echo -e "[${WHITE}Ok${NC}] Updating package and distribution "
	apt-get update
	#echo -e "${WHITE}"
	#apt-get dist-upgrade -y  #We're going to comment this, it speed up our worker creation :) 
	#echo -e "${NC}"
}

autoremove_go() {
	echo -e "[${WHITE}Ok${NC}] Cleaning unnecesary packages"
	echo -e "${WHITE}"
	apt-get -y autoremove
	echo -e "${NC}"
}

tools_go() {
	# Install basic tools
	echo -e "[${WHITE}Ok${NC}] Installing all required packages"
	apt-get -y install build-essential binutils-doc git subversion mpic++ g++ gcc mpich
}

hostnames_go(){
	echo "10.11.12.50 master">>/etc/hosts
	echo "10.11.12.51 worker1">>/etc/hosts
	echo "10.11.12.52 worker2">>/etc/hosts
	echo "10.11.12.53 worker3">>/etc/hosts
}

sshkeys_copy(){
      # we only generate the key on one of the nodes, then we copy this to other nodes.
      echo -e "[${WHITE}Ok${NC}] Creating SSH_Keys"
      if [[ ! -e /vagrant/id_rsa ]]; then
        ssh-keygen -t rsa -b 4096 -f /vagrant/id_rsa -N ""
      fi
      
      (echo; cat /vagrant/id_rsa.pub) >> /home/vagrant/.ssh/authorized_keys
      cp /vagrant/id_rsa* /home/vagrant/.ssh/
      chown vagrant:vagrant /home/vagrant/.ssh/id_rsa*
}

nfs_folder(){
        echo -e "[${WHITE}Ok${NC}] Setting up Shared FileSystem"

	if [ "$HOSTNAME" = "master" ]; then
 		echo -e "[${WHITE}Ok${NC}] Installing NFS on Master Node"
		mkdir /home/vagrant/cloud	#Create the cloud folder to shared accross the cluster :) 
		chown vagrant:vagrant  /home/vagrant/cloud
		apt install -y nfs-server
		echo "/home/vagrant/cloud *(rw,sync,no_root_squash,no_subtree_check)">>/etc/exports	#Persistence against reboots.
		exportfs -a
		service nfs-kernel-server restart
	else 
		echo -e "[${WHITE}Ok${NC}] Installing NFS on Worker Node"
		apt install -y nfs-common
		mkdir /home/vagrant/cloud
		chown vagrant:vagrant  /home/vagrant/cloud
		mount -t nfs master:/home/vagrant/cloud /home/vagrant/cloud
		echo "master:/home/vagrant/cloud /home/vagrant/cloud nfs">>/etc/fstab 
		df -h
	fi

	echo -e "[${YELLOW}Ok${NC}]NFS DONE"
}

test_connectionssh(){
   machines=(master worker1 worker2 worker3)
   for h in ${machines[@]}; 
   do  yes yes | ssh vagrant@$h
   done
}

main
exit 0


