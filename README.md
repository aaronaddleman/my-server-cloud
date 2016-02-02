# my-server-cloud

The purpose of this project is to have a playground for various setups.

## Installation

Versions used:

Vagrant 1.7.4
Chef Development Kit Version: 0.10.0
chef-client version: 12.5.1
berks version: 4.0.1
kitchen version: 1.4.2

22:40:47 (master U:1 ✗) my-server-cloud vagrant plugin list
chef (12.3.0)
vagrant-cachier (1.2.0)
vagrant-share (1.1.4, system)

http://www.xquartz.org/

1. clone
1. bundle install
1. vagrant plugin install chef
1. berks vendor cookbooks

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

## Getting cookbook updates

1. after cloaning repo
1. git submodule init
1. git submodule update
