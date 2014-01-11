current_dir = Dir.pwd
$stdout.puts "From knife: #{current_dir}"
cookbook_path ['#{current_dir}/chef/cookbooks']
