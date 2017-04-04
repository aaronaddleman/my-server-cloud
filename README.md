# my-server-cloud

The purpose of this project is to have a playground for various setups.

## Installation


1. git clone https://github.com/aaronaddleman/my-server-cloud.git
1. git submodule init
1. git submodule update
1. bundle install
1. vagrant plugin install chef
1. vagrant plugin install vagrant-vbguest
1. berks vendor cookbooks
1. vagrant up chef_server
1. (let install run)
1. At the end, you should be able to visit `http://192.168.0.10`
1. Login with your selected credentials
1. To make nodes:
1. vagrant up chef_first_client
1. vagrant up chef_second_client

## Credentials

Locate the line below and change to what you like:

```
chef-server-ctl user-create aaddleman Aaron Addleman aaronaddleman@gmail.com changeme --filename /mnt/dot_chef/aaddleman.pem
```

The above line creates an account of `aaronaddleman@gmail.com` with the password of `changeme` to be used for authenticating with the console of Chef.

## Current state

Chef Server = latest

## First time building

When building for the first time, you should create a user and org, then get the starter-kit to config the files:

.chef/knife.rb
ORG-validator.pem
USR.pem

This will help with creating additional VMs with vagrant and have them all point to the same certs for permissions.

## Updating roles

When making changes to a role, you can update the chef server with the command:

```
knife role from file roles/router.json
```

1. after cloaning repo
1. git submodule init
1. git submodule update

## Updating cookbooks

TODO
