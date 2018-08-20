# -*- mode: ruby -*-
# vi: set ft=ruby :


# https://github.com/hashicorp/vagrant/issues/1874#issuecomment-165904024
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |p|
    pm = Vagrant::Plugin::Manager.new(
      Vagrant::Plugin::Manager.user_plugins_file
    )
    plugin_hash = pm.installed_plugins
    next if plugin_hash.has_key?(p)
    result = true
    logger.warn("Installing plugin #{p}")
    pm.install_plugin(p)
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

required_plugins = ['vagrant-hosts', 'vagrant-share', 'vagrant-vbox-snapshot', 'vagrant-host-shell', 'vagrant-reload']
ensure_plugins required_plugins



Vagrant.configure(2) do |config|
  config.vm.define "central_mail_server" do |central_mail_server_config|
    central_mail_server_config.vm.box = "bento/centos-7.5"
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
    mail_client_config.vm.box = "bento/centos-7.5"
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
    null_client_config.vm.box = "bento/centos-7.5"
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