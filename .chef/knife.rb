current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "aaddleman"
client_key               "#{current_dir}/aaddleman.pem"
validation_client_name   "fullaccess-validator"
validation_key           "#{current_dir}/fullaccess-validator.pem"
chef_server_url          "https://192.168.0.10/organizations/fullaccess"
syntax_check_cache_path  "#{ENV['HOME']}/.chef/syntaxcache"
ssl_verify_mode          :verify_none
cookbook_path            "#{current_dir}/../cookbooks"
node_path                 "#{current_dir}/../nodes" 
role_path                 "#{current_dir}/../roles"
data_bag_path             "#{current_dir}/../data_bags"
environment_path          "#{current_dir}/../environments"
