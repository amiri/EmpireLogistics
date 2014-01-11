current_dir = Dir.pwd
$stdout.puts "From solo: #{current_dir}"
file_cache_path "#{current_dir}/chef-cache/"
cookbook_path "#{current_dir}/chef/cookbooks/"
