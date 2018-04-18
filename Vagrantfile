# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  config.vm.define "central_mail_server" do |central_mail_server_config|
    central_mail_server_config.vm.box = "bento/centos-7.4"
    central_mail_server_config.vm.hostname = "central-mail-server.cb.net"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    central_mail_server_config.vm.network "private_network", ip: "10.1.4.10", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    central_mail_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_central_mail_server"
    end

    central_mail_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    central_mail_server_config.vm.provision "shell", path: "scripts/setup_central_mail_server.sh", privileged: true
  end


  config.vm.define "mail_client" do |mail_client_config|
    mail_client_config.vm.box = "bento/centos-7.4"
    mail_client_config.vm.hostname = "mail-client.cb.net"
    mail_client_config.vm.network "private_network", ip: "10.1.4.12", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    mail_client_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_mail_client"
    end

    mail_client_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    mail_client_config.vm.provision "shell", path: "scripts/setup_mail_client.sh", privileged: true
  end


  config.vm.define "null_client" do |null_client_config|
    null_client_config.vm.box = "bento/centos-7.4"
    null_client_config.vm.hostname = "null-client.cb.net"
    null_client_config.vm.network "private_network", ip: "10.1.4.11", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    null_client_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_null_client"
    end

    null_client_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    null_client_config.vm.provision "shell", path: "scripts/setup_null_client.sh", privileged: true
  end




  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '10.1.4.10', ['central-mail-server.cb.net']
    provisioner.add_host '10.1.4.11', ['null-client.cb.net']
    provisioner.add_host '10.1.4.12', ['mail-client.cb.net']
  end

end