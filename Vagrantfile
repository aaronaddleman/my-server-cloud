# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rubygems'
require 'chef'
require 'json'

# read in the knife.rb for setting options for provisioning to chef server and mapping dirs to hosting environment
Chef::Config.from_file(File.join(File.dirname(__FILE__), '.chef', 'knife.rb'))

# read the settings from the node and use them below when defining chef options for vagrant provisioning
chef_server_json = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'chef-server.example.com.json').read)

# script to create organizations and user accounts
$user_and_org = <<SCRIPT
chef-server-ctl user-list | grep aaddleman | wc -l && \
chef-server-ctl user-create aaddleman Aaron Addleman aaronaddleman@gmail.com changeme --filename /mnt/dot_chef/aaddleman.pem
chef-server-ctl org-create ninthport ninthport --association_user aaddleman --filename /mnt/dot_chef/ninthport-validator.pem
chef-server-ctl org-create fullaccess fullaccess --association_user aaddleman --filename /mnt/dot_chef/fullaccess-validator.pem
chef-server-ctl org-create trustedorg trustedorg --association_user aaddleman --filename /mnt/dot_chef/trustedorg-validator.pem
chef-server-ctl org-create untrustedorg untrustedorg --association_user aaddleman --filename /mnt/dot_chef/untrustedorg-validator.pem
SCRIPT

# management console
$management_console = <<SCRIPT
chef-server-ctl install opscode-manage
opscode-manage-ctl reconfigure
chef-server-ctl reconfigure
SCRIPT

# push jobs
$push_jobs = <<SCRIPT
chef-server-ctl install opscode-push-jobs-server
opscode-push-jobs-server-ctl reconfigure
chef-server-ctl reconfigure
SCRIPT

# replication
$replication = <<SCRIPT
chef-server-ctl install chef-sync
chef-sync-ctl reconfigure
chef-server-ctl reconfigure
SCRIPT

# chef reporting
$reporting = <<SCRIPT
chef-server-ctl install opscode-reporting
opscode-reporting-ctl reconfigure
chef-server-ctl reconfigure
SCRIPT

# install chef gem
# TODO


Vagrant.configure(2) do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end


  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on the "Usage" link above
    config.cache.scope = :box
    config.cache.auto_detect
    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    # config.cache.synced_folder_opts = {
    #   type: :nfs,
    #   # The nolock option can be useful for an NFSv3 client that wants to avoid the
    #   # NLM sideband protocol. Without this option, apt-get might hang if it tries
    #   # to lock files needed for /var/cache/* operations. All of this can be avoided
    #   # by using NFSv4 everywhere. Please note that the tcp option is not the default.
    #   mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    # }
  end

  # chef server
  config.vm.define :chef_server_centos66 do |chef_server|
    chef_server.vm.box = "chef/centos-6.6"
    chef_server.vm.network "private_network", ip: "192.168.0.10"
    chef_server.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    chef_server.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
    chef_server.vm.hostname = "chefserver"
    chef_server.vm.synced_folder ".chef/", "/mnt/dot_chef"

    chef_server.vm.provision :chef_solo do |chef|

      chef.add_recipe "chef-server"
      chef.log_level = "debug"
      chef.cookbooks_path = Chef::Config[:cookbook_path]
      chef.roles_path = Chef::Config[:role_path]
      chef.data_bags_path = Chef::Config[:data_bag_path]
      chef.environments_path = Chef::Config[:environment_path]
      # chef.node_name = 'chef-server.example.com'
      chef.run_list = chef_server_json.delete('run_list')
      chef.json = chef_server_json
    end

    # user_and_org
    chef_server.vm.provision "shell", inline: $user_and_org 

    # management console
    chef_server.vm.provision "shell", inline: $management_console 

    # push jobs
    #chef_server.vm.provision "shell", inline: $push_jobs 

    # replication
    #chef_server.vm.provision "shell", inline: $replication 

    # chef reporting
    #chef_server.vm.provision "shell", inline: $reporting 
  end

  # dev station
  config.vm.define :chef_dev do |chef_client|
    chef_client.vm.hostname = "dev.example.com"
    chef_client.vm.box = "chef/centos-6.6"
    chef_client.vm.network "private_network", ip: "192.168.0.20"
    chef_server.vm.synced_folder ".chef/", "/mnt/.chef"
    chef_server.vm.synced_folder "cookbooks/", "/mnt/cookbook"
    chef_server.vm.synced_folder "data_bags/", "/mnt/data_bags"
    chef_server.vm.synced_folder "environments/", "/mnt/environments"
    chef_server.vm.synced_folder "nodes/", "/mnt/nodes"
    chef_server.vm.synced_folder "roles/", "/mnt/roles"

    chef_client.vm.provision :chef_client do |chef|
      chef.log_level = "debug"
      chef.chef_server_url = Chef::Config[:chef_server_url]
      chef.validation_key_path = Chef::Config[:validation_key]
      chef.validation_client_name = Chef::Config[:validation_client_name]
      chef.add_role("chefdev")
      chef.delete_node = true
      chef.delete_client = true
    end
  end


  # first client

  config.vm.define :chef_first_client do |chef_client|
    chef_client.vm.box = "chef/centos-6.6"
    chef_client.vm.network "private_network", ip: "192.168.0.21"

    chef_client.vm.provision :chef_client do |chef|
      chef.log_level = "debug"
      chef.chef_server_url = Chef::Config[:chef_server_url]
      chef.validation_key_path = Chef::Config[:validation_key]
      chef.validation_client_name = Chef::Config[:validation_client_name]
      chef.node_name = 'first.example.com'
      chef.delete_node = true
      chef.delete_client = true
    end

  end

  # second client
  config.vm.define :chef_second_client do |chef_client|
    chef_client.vm.box = "chef/centos-6.6"
    chef_client.vm.network "private_network", ip: "192.168.0.22"

    chef_client.vm.provision :chef_client do |chef|
      chef.chef_server_url = Chef::Config[:chef_server_url]
      chef.validation_key_path = Chef::Config[:validation_key]
      chef.validation_client_name = Chef::Config[:validation_client_name]
      chef.node_name = 'second.example.com'
      chef.delete_node = true
      chef.delete_client = true
    end
  end

  # router client
  config.vm.define :chef_router_client do |chef_client|
    chef_client.vm.hostname = "router.example.com"
    chef_client.vm.box = "chef/centos-6.6"
    chef_client.vm.network "private_network", ip: "192.168.0.2"
    chef_client.vm.network "private_network", ip: "192.168.0.3"
    chef_client.vm.network "private_network", ip: "192.168.20.2"
    chef_client.vm.network "private_network", ip: "192.168.20.3"

    chef_client.vm.provision :chef_client do |chef|
      chef.chef_server_url = Chef::Config[:chef_server_url]
      chef.validation_key_path = Chef::Config[:validation_key]
      chef.validation_client_name = Chef::Config[:validation_client_name]
      #chef.node_name = 'router.example.com'
      chef.add_role("router")
      chef.delete_node = true
      chef.delete_client = true
    end
  end

  # router client
  config.vm.define :chef_host1_client do |chef_client|
    chef_client.vm.hostname = "host1.example.com"
    chef_client.vm.box = "chef/centos-6.6"
    chef_client.vm.network "private_network", ip: "192.168.20.20"

    chef_client.vm.provision :chef_client do |chef|
      chef.chef_server_url = Chef::Config[:chef_server_url]
      chef.validation_key_path = Chef::Config[:validation_key]
      chef.validation_client_name = Chef::Config[:validation_client_name]
      chef.add_role("nginx")
      chef.delete_node = true
      chef.delete_client = true
    end
  end


end
