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
  config.vm.define "mail_receiving_server" do |mail_receiving_server_config|
    mail_receiving_server_config.vm.box = "bento/centos-7.4"
    mail_receiving_server_config.vm.hostname = "mail-receiving-server.example.com"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    mail_receiving_server_config.vm.network "private_network", ip: "10.1.4.10", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    mail_receiving_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_mail_receiving_server"
    end

    mail_receiving_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    mail_receiving_server_config.vm.provision "shell", path: "scripts/samba_server_setup.sh", privileged: true
  end


  config.vm.define "mail_sending_server" do |mail_sending_server_config|
    mail_sending_server_config.vm.box = "bento/centos-7.4"
    mail_sending_server_config.vm.hostname = "mail-sending-server.example.com"
    mail_sending_server_config.vm.network "private_network", ip: "10.1.4.11", :netmask => "255.255.255.0", virtualbox__intnet: "intnet2"

    mail_sending_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_mail_sending_server"
    end

    mail_sending_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    mail_sending_server_config.vm.provision "shell", path: "scripts/mail_sending_server_setup.sh", privileged: true
  end

  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '10.1.4.10', ['mail-receiving-server.example.com']
    provisioner.add_host '10.1.4.11', ['mail-sending-server.example.com']
  end

end