# my-server-cloud

The purpose of this project is to have a playground for various setups.

## Installation

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
