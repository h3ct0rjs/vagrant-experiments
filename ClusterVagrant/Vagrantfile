# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision "shell", path: "provision.sh"

  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/bionic64"
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "10.11.12.50"
  end

  config.vm.define "worker1" do |worker1|
    worker1.vm.box = "ubuntu/bionic64"
    worker1.vm.hostname = "worker1"
    worker1.vm.network :private_network, ip: "10.11.12.51"
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.box = "ubuntu/bionic64"
    worker2.vm.hostname = "worker2"
    worker2.vm.network :private_network, ip: "10.11.12.52"
  end
  
  config.vm.define "worker3" do |worker3|
    worker3.vm.box = "ubuntu/bionic64"
    worker3.vm.hostname = "worker3"
    worker3.vm.network :private_network, ip: "10.11.12.53"
  end
end
