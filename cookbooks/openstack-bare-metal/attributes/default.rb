# encoding: UTF-8
#
# Cookbook Name:: openstack-bare-metal
# Attributes:: default
#
# Copyright 2015, IBM, Corp
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default['openstack']['bare-metal']['custom_template_banner'] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

default['openstack']['bare-metal']['verbose'] = 'false'
default['openstack']['bare-metal']['debug'] = 'false'

# Maximum number of worker threads that can be started
# simultaneously by a periodic task. Should be less than RPC
# thread pool size. (integer value)
default['openstack']['bare-metal']['conductor']['periodic_max_workers'] = 8

# The size of the workers greenthread pool. (integer value)
default['openstack']['bare-metal']['conductor']['workers_pool_size'] = 100

# Common rpc definitions
default['openstack']['bare-metal']['rpc_thread_pool_size'] = 64
default['openstack']['bare-metal']['rpc_conn_pool_size'] = 30
default['openstack']['bare-metal']['rpc_response_timeout'] = 60

# The name of the Chef role that knows about the message queue server
# that Ironic uses
default['openstack']['bare-metal']['rabbit_server_chef_role'] = 'os-ops-messaging'

case node['openstack']['mq']['service_type']
when 'rabbitmq'
  default['openstack']['bare-metal']['rpc_backend'] = 'rabbit'
when 'qpid'
  default['openstack']['bare-metal']['rpc_backend'] = 'qpid'
end

# The AMQP exchange to connect to if using RabbitMQ or Qpid
default['openstack']['bare-metal']['control_exchange'] =  node['openstack']['mq']['bare-metal']['control_exchange']

# Logging stuff
default['openstack']['bare-metal']['log_dir'] = '/var/log/ironic'

default['openstack']['bare-metal']['syslog']['use'] = false
default['openstack']['bare-metal']['syslog']['facility'] = 'LOG_LOCAL1'
default['openstack']['bare-metal']['syslog']['config_facility'] = 'local1'

default['openstack']['bare-metal']['region'] = node['openstack']['region']

# Keystone settings
default['openstack']['bare-metal']['api']['auth_strategy'] = 'keystone'

default['openstack']['bare-metal']['api']['auth']['version'] = node['openstack']['api']['auth']['version']

# Whether to allow the client to perform insecure SSL (https) requests
default['openstack']['bare-metal']['api']['auth']['insecure'] = false

# Keystone PKI signing directories
default['openstack']['bare-metal']['api']['auth']['cache_dir'] = '/var/cache/ironic/api'

default['openstack']['bare-metal']['service_tenant_name'] = 'service'
default['openstack']['bare-metal']['service_user'] = 'ironic'
default['openstack']['bare-metal']['service_role'] = 'admin'

default['openstack']['bare-metal']['user'] = 'ironic'
default['openstack']['bare-metal']['group'] = 'ironic'

# Setup the tftp variables
default['openstack']['bare-metal']['tftp']['enabled'] = false
# IP address of Ironic compute node's tftp server
default['openstack']['bare-metal']['tftp']['server'] = '127.0.0.1'
# Ironic compute node's tftp root path
default['openstack']['bare-metal']['tftp']['root_path'] = '/var/lib/tftpboot'
# Directory where master tftp images are stored on disk
default['openstack']['bare-metal']['tftp']['master_path'] = "#{node['openstack']['bare-metal']['tftp']['root_path']}/master_images"

# rootwrap.conf
default['openstack']['bare-metal']['rootwrap']['filters_path'] = '/etc/ironic/rootwrap.d,/usr/share/ironic/rootwrap'
default['openstack']['bare-metal']['rootwrap']['exec_dirs'] = '/sbin,/usr/sbin,/bin,/usr/bin'
default['openstack']['bare-metal']['rootwrap']['use_syslog'] = false
default['openstack']['bare-metal']['rootwrap']['syslog_log_facility'] = 'syslog'
default['openstack']['bare-metal']['rootwrap']['syslog_log_level'] = 'ERROR'

case platform_family
when 'fedora', 'rhel'
  default['openstack']['bare-metal']['platform'] = {
    'ironic_api_packages' => ['openstack-ironic-api'],
    'ironic_api_service' => 'openstack-ironic-api',
    'ironic_conductor_packages' => ['openstack-ironic-conductor', 'shellinabox', 'ipmitool'],
    'ironic_conductor_service' => 'openstack-ironic-conductor',
    'ironic_common_packages' => ['openstack-ironic-common', 'python-ironicclient']
  }
when 'debian'
  default['openstack']['bare-metal']['platform'] = {
    'ironic_api_packages' => ['ironic-api'],
    'ironic_api_service' => 'ironic-api',
    'ironic_conductor_packages' => ['ironic-conductor', 'shellinabox', 'ipmitool'],
    'ironic_conductor_service' => 'ironic-conductor',
    'ironic_common_packages' => ['python-ironicclient', 'ironic-common']
  }
end
