# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    config.vm.box = "scotch/box"
    config.vm.network "private_network", ip: "192.168.33.11"
    config.vm.hostname = "scotchbox"
    #Used by vagrant to display a webpage of installed stuff.
    config.vm.synced_folder "./public", "/var/www/public", :mount_options => ["dmode=777", "fmode=666"]
    config.vm.synced_folder "../WEBSITE", "/var/www/html", :mount_options => ["dmode=777", "fmode=666"]
    

	config.vm.provider :virtualbox do |vb|
		vb.customize ["modifyvm", :id, "--memory", "2048"]
		vb.customize ["modifyvm", :id, "--cpus"  , 2]
	end

    
    # Optional NFS. Make sure to remove other synced_folder line too
    #config.vm.synced_folder ".", "/var/www", :nfs => { :mount_options => ["dmode=777","fmode=666"] }

    config.vm.provision :shell, path: "provision.sh"
end
