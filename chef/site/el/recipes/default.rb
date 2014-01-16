#
# Cookbook Name:: el
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

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

node["el"]["apt_packages"].each do |package|
  apt_package package do
    action :install
  end
end

deploy_revision "empirelogistics" do
  repo "http://github.com/amiri/EmpireLogistics.git"
  deploy_to "/var/local/EmpireLogistics"
  revision "HEAD"
  user "el"
  enable_submodules true
  environment "production"
  shallow_clone true
  keep_releases 10
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  symlink_before_migrate nil
  create_dirs_before_symlink   []
  purge_before_symlink         []
  symlinks                     ({"logs"=>"logs"}) 
  scm_provider Chef::Provider::Git
  notifies :restart, "service[uwsgi]"
end

include_recipe "perlbrew"

perlbrew_perl "5.18.2" do
  version 'perl-5.18.2'
  action :install
end

perlbrew_lib "perl-5.18.2@extlib" do
  action :create
end

# execute script to install extlib

include_recipe "carton"

#carton_app "hello-world" do
  #perlbrew node['hello-world']['perl_version']
  #command "starman -p #{node['hello-world']['port']} app.psgi"
  #cwd node['hello-world']['deploy_dir']
  #user node['hello-world']['user']
  #group node['hello-world']['group']
#end

execute "python_dev_packages" do
  #command "sudo apt-get -y build-dep python2.7 python-stdlib-extensions python-bsddb3"
  command "sudo apt-get -y build-dep python2.7 python-stdlib-extensions"
end

include_recipe "python"

include_recipe "postgresql"
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
include_recipe "nginx"
include_recipe "uwsgi::emperor"
include_recipe "nodejs"
include_recipe "npm"
include_recipe "sudo"

include_recipe "perl"
node["el"]["system_perl_packages"].each do |package|
  cpan_module package
end

node["el"]["pip_packages"].each do |package|
    python_pip package do
      virtualenv "/var/local/EmpireLogistics/current/python"
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
  path "/etc/nginx/sites-enabled/empirelogistics"
  action :create_if_missing
end

%w{uwsgi nginx}.each do |service|
  service service do
    action :restart
  end
end
