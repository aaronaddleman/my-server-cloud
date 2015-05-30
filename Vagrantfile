# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rubygems'
require 'chef'
require 'json'

# read in the knife.rb for setting options for provisioning to chef server and mapping dirs to hosting environment
Chef::Config.from_file(File.join(File.dirname(__FILE__), '.chef', 'knife.rb'))

# read the settings from the node and use them below when defining chef options for vagrant provisioning
chef_server_json = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'chef-server.example.com.json').read)

Vagrant.configure(2) do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define :chef_server_centos66 do |chef_server|
    chef_server.vm.box = "chef/centos-6.6"
    chef_server.vm.network "private_network", ip: "10.33.33.33"
    chef_server.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    chef_server.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
    chef_server.vm.hostname = "chefserver"

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
  end

  # first client
  config.vm.define :chef_first_client do |chef_client|
    chef_client.vm.box = "chef/centos-6.6"
    chef_client.vm.network "private_network", ip: "10.33.33.34" 

    chef_client.vm.provision :chef_client do |chef| 
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
    chef_client.vm.network "private_network", ip: "10.33.33.35" 

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
    chef_client.vm.network "private_network", ip: "10.33.33.40"
    chef_client.vm.network "private_network", ip: "10.33.33.41"
    chef_client.vm.network "private_network", ip: "10.33.30.10"
    chef_client.vm.network "private_network", ip: "10.33.30.11" 

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


end
