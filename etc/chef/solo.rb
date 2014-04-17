current_dir = Dir.pwd
file_cache_path "#{current_dir}/chef-cache/"
cookbook_path [
    "#{current_dir}/chef/cookbooks/",
    "#{current_dir}/chef/site-cookbooks/"
]
data_bag_path "#{current_dir}/chef/data_bags"
ssl_verify_mode :verify_peer
