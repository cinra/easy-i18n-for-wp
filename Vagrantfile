# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos6.5"
  config.vm.box_url = "http://www.lyricalsoftware.com/downloads/centos65.box"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: "192.168.33.5"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "www", "/var/www"
  # config.vm.synced_folder "www", "/var/www", owner:'cinra', group:'www', mount_options:['dmode=777','fmode=755']

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true

      # Customize the amount of memory on the VM:
      vb.memory = "1024"

      vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline <<-SHELL
  #   sudo apt-get install apache2
  # SHELL

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "chef/site-cookbooks/"
    chef.run_list = %w[
      recipe[adduser]
      recipe[git]
      recipe[httpd]
      recipe[php]
      recipe[mysql]
    ]
    chef.json = {
      domain: 'cinra.dev',
      charset: 'UTF-8',
      timezone: 'Asia/Tokyo',
      user: {
        name: 'cinra',
        password: '$1$YNdSNIME$WtiakACxxXT.hNkeCVcRS.',# openssl passwd -1 'test'
        group: 'www',
        home: '/var',
      },
      httpd: {
        document_root: '/var/www/html',
        error_log: '/var/log/httpd/error_log',
        access_log: '/var/log/httpd/access_log combined'
      },
      php: {
        post_max_size: '32M',
        upload_max_filesize: '32M'
      },
      mysql: {
        user: 'cinra',
        password: 'test',
        dbname: 'test',
        root_password: 'test'
      }
    }
  end

  config.vm.provision :shell, run: "always", :inline => <<-EOT
    sudo service httpd restart
    sudo service mysqld restart
  EOT
end
