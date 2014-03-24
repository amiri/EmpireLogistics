#
# Cookbook Name:: el
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

execute "apt_get_update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

node["el"]["apt_packages"].each do |package|
  apt_package package do
    action :install
  end
end

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

execute "fix_locale" do
  command "export LANGUAGE=en_US.UTF-8 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && locale-gen en_US.UTF-8 && dpkg-reconfigure locales"
end

include_recipe "locale"

node["authorization"]["sudo"]["groups"].each do |group|
  group group do
    action :create
  end
end

user "el" do
  supports :manage_home => true
  comment "Empire Logistics"
  uid 1917
  gid "admin"
  home "/home/el"
  shell "/bin/bash"
end

user "amiri" do
  supports :manage_home => true
  comment "Amiri Barksdale"
  uid 1918
  gid "admin"
  home "/home/amiri"
  shell "/bin/bash"
end

group "el" do
  action :create
  gid 1917
  members ["amiri","el","www-data"]
  append true
end

directory "/var/uwsgi" do
  owner "el"
  group "el"
  mode 00774
  action :create
end

remote_directory "/var/local/EmpireLogistics" do
  owner "el"
  group "el"
  files_owner "el"
  files_group "el"
  files_mode 0774
  recursive true
  source "EmpireLogistics"
  cookbook "el"
  action :create_if_missing
end

# This is stupid, because chef won't change perms of parent directories
# in recipe above
execute "chmod" do
  cwd '/var/local/EmpireLogistics'
  command "chown -Rf el:el /var/local/EmpireLogistics"
end

deploy_revision "empirelogistics" do
  repo "http://github.com/amiri/EmpireLogistics.git"
  deploy_to "/var/local/EmpireLogistics"
  revision "HEAD"
  user "el"
  enable_submodules false
  environment "production"
  shallow_clone true
  keep_releases 10
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  symlink_before_migrate       nil
  create_dirs_before_symlink   []
  purge_before_symlink         []
  symlinks                     ({"logs" => "logs","local" => "local","perl" => "perl", "python" => "python", "tiles" => "tiles"})
  scm_provider Chef::Provider::Git
end

include_recipe "perlbrew"

perlbrew_perl "5.18.2" do
  version 'perl-5.18.2'
  action :install
end

# 
perlbrew_cpanm "basics" do
  perlbrew "perl-5.18.2"
  modules ["Carton","local::lib"]
  options "-n"
end

# Could not install this with Carton
perlbrew_cpanm "Spiffy" do
  perlbrew "perl-5.18.2"
  modules ["Spiffy"]
  options "-n -L /var/local/EmpireLogistics/shared/local"
end

perlbrew_run 'install_app_local_lib' do
  perlbrew 'perl-5.18.2'
  cwd "/var/local/EmpireLogistics/current/"
  command "carton install --deployment --cached"
end

bash "el_perl_env" do
  action :run
  user "el"
  user "el"
  code <<-EOH
  cd /home/el/ && echo 'source "/var/local/EmpireLogistics/shared/perl/etc/bashrc"' >> /home/el/.bashrc && source /home/el/.bashrc
  EOH
end

execute "compile_uwsgi" do
  user "el"
  user "el"
  command <<-EOH
  perlbrew switch perl-5.18.2 && curl http://uwsgi.it/install | bash -s psgi /var/local/EmpireLogistics/shared/local/bin/uwsgi 
  EOH
  creates "/var/local/EmpireLogistics/shared/local/bin/uwsgi"
  action :run
end

# Install libGeoIP.so.1.4.8 so nginx::source doesn't have to.
node.default['nginx']['geoip']['lib_url'] = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-#{node['nginx']['geoip']['lib_version']}.tar.gz"
geolib_filename = ::File.basename(node['nginx']['geoip']['lib_url'])
geolib_filepath = "#{Chef::Config['file_cache_path']}/#{geolib_filename}"

remote_file geolib_filepath do
  source   "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-#{node['nginx']['geoip']['lib_version']}.tar.gz"
  checksum node['nginx']['geoip']['lib_checksum']
  owner    'root'
  group    'root'
  mode     '0644'
end

bash "extract_geolib" do
  action "run"
  code <<-EOH
    tar xzvf #{geolib_filepath} -C #{::File.dirname(geolib_filepath)}
    cd GeoIP-#{node['nginx']['geoip']['lib_version']}
    autoreconf --force --install
    which libtoolize && libtoolize -f
    ./configure
    make && make install
  EOH
  creates "/usr/local/lib/libGeoIP.so.1.4.8"
  cwd ::File.dirname(geolib_filepath)
end

pg_database "empirelogistics" do
  action :drop
end

pg_database "pgloader" do
  action :drop
end

directory "/var/run/postgresql" do
  owner "root"
  group "root"
  mode '777'
  action :create
end

include_recipe "postgresql"
execute "chmod" do
  command "chown -Rf postgres:postgres /var/run/postgresql"
end
include_recipe "postgresql::apt_repository"
include_recipe "postgresql::postgis"
include_recipe "postgresql::server"
include_recipe "postgresql::server_dev"
include_recipe "postgresql::data_directory"
include_recipe "postgresql::contrib"
include_recipe "postgresql::configuration"
include_recipe "postgresql::libpq"
include_recipe "postgresql::client"
include_recipe "postgresql::pg_user"
include_recipe "postgresql::pg_database"
include_recipe "postgresql::service"
include_recipe "nginx::source"
include_recipe "uwsgi::emperor"
include_recipe "nodejs"
include_recipe "npm"
include_recipe "sudo"
include_recipe "perl"

execute "python_dev_packages" do
  command "sudo apt-get -y build-dep python2.7 python-stdlib-extensions"
end

include_recipe "python"


node["el"]["hold_packages"].each do |package|
  execute "hold_package" do
    command "echo '#{package} hold' | dpkg --set-selections"
  end
end

node["el"]["system_perl_packages"].each do |package|
  cpan_module package
end

node["el"]["pip_packages"].each do |package|
    python_pip package do
      virtualenv "/var/local/EmpireLogistics/shared/python"
      action :install
      options "-U --allow-all-external --process-dependency-links --allow-unverified psycopg2 --allow-unverified PIL --allow-unverified Shapely --allow-unverified ModestMaps --allow-unverified simplejson --allow-unverified werkzeug --allow-unverified #{package}"
    end
end

node["el"]["npm_packages"].each do |package|
  npm_package package do
    action :install
  end
end

cookbook_file "nginx.conf" do
  path "#{node["nginx"]["dir"]}/sites-enabled/empirelogistics"
  action :create_if_missing
end

%w{uwsgi nginx}.each do |service|
  service service do
    action :restart
  end
end

cron "compress_tiles" do
  minute "0"
  hour "*"
  user "el"
  mailto "amiribarksdale@gmail.com"
  home "/home/el"
  command %Q{find /var/local/EmpireLogistics/shared/tiles -type f -name "*.json" -print0 | xargs -0r gzip -q -k}
end
