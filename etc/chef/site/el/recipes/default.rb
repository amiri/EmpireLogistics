#
# Cookbook Name:: el
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

if ::Dir.exists?("/home/el/")
    node.default['env']['user'] = 'el'
else
    node.default['env']['user'] = 'root'
end

execute "apt_get_update" do
  command "apt-get update"
  ignore_failure true
  action :run
end

execute "apt_get_update" do
  command "apt-get -y dist-upgrade"
  ignore_failure true
  action :run
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
  action :create
end

user "amiri" do
  supports :manage_home => true
  comment "Amiri Barksdale"
  uid 1918
  gid "admin"
  home "/home/amiri"
  shell "/bin/bash"
  action :create
end

group "el" do
  action :create
  gid 1917
  members ["amiri","el","www-data"]
  append true
  action :create
end

execute "remove_uwsgi" do
  command "apt-get -y --purge autoremove uwsgi-*"
  returns [0,100]
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
execute "chown" do
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
  symlinks                     ({"backups" => "backups", "logs" => "logs","local" => "local","perl" => "perl", "python" => "python", "tiles" => "tiles"})
  scm_provider Chef::Provider::Git
end

include_recipe "perlbrew"

perlbrew_perl "perl-5.18.2" do
  version 'perl-5.18.2'
  action :install
end

perlbrew_cpanm "basics" do
  perlbrew "perl-5.18.2"
  modules ["Carton","local::lib"]
  options "-n"
  action :run
end

# Could not install this with Carton
perlbrew_cpanm "Spiffy" do
  perlbrew "perl-5.18.2"
  modules ["Spiffy"]
  options "-n -L /var/local/EmpireLogistics/shared/local"
  action :run
end

perlbrew_run 'install_app_local_lib' do
  perlbrew 'perl-5.18.2'
  cwd "/var/local/EmpireLogistics/current/"
  command "carton install --deployment --cached"
  action :run
end

bash "el_perl_env" do
  action :run
  user "el"
  group "el"
  cwd "/home/el"
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  code <<-EOH
  cd /home/el/ && echo 'source "/var/local/EmpireLogistics/shared/perl/etc/bashrc"' >> /home/el/.bashrc && source /home/el/.profile
  EOH
  action :run
end

bash 'switch' do
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  user "el"
  group "el"
  command "perlbrew switch perl-5.18.2"
  action :run
end

execute "chown" do
  cwd '/var/local/EmpireLogistics'
  command "chown -Rf el:el /var/local/EmpireLogistics"
end

# Install libGeoIP.so.1.4.8 so nginx::source doesn't have to.
node.default['nginx']['geoip']['lib_url'] = "http://geolite.maxmind.com/download/geoip/api/c/GeoIP-#{node['nginx']['geoip']['lib_version']}.tar.gz"
geolib_filename = ::File.basename(node['nginx']['geoip']['lib_url'])
geolib_filepath = "#{Chef::Config['file_cache_path']}#{geolib_filename}"

remote_file geolib_filepath do
  source   "#{node['nginx']['geoip']['lib_url']}.tar.gz"
  checksum node['nginx']['geoip']['lib_checksum']
  owner    'root'
  group    'root'
  mode     '0644'
  not_if { ::File.exists?("/usr/local/lib/libGeoIP.so.1.4.8") }
end

bash "extract_geolib" do
  action :run
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

directory "/var/run/postgresql" do
  owner "root"
  group "root"
  mode '777'
  action :create
end

include_recipe "postgresql"
execute "chown" do
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
include_recipe "nodejs"
include_recipe "npm"
include_recipe "sudo"
include_recipe "perl"

bash "sqitch" do
  user "el"
  group "el"
  cwd "/var/local/EmpireLogistics/current"
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  code <<-EOH
    cd /var/local/EmpireLogistics/current
    /var/local/EmpireLogistics/current/local/bin/sqitch --top-dir etc/schema deploy
    /var/local/EmpireLogistics/current/local/bin/sqitch --top-dir etc/schema verify
  EOH
  action :run
end

cookbook_file "uwsgi.conf" do
  source "/etc/init/uwsgi.conf"
  path "/etc/init/uwsgi.conf"
  owner    'root'
  group    'root'
  mode     '0644'
  action :create
end

execute "python_dev_packages" do
  command "sudo apt-get -y build-dep python2.7 python-stdlib-extensions"
end

include_recipe "el-python"

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

# Install uwsgi with psgi and python plugins
uwsgi_filename = ::File.basename(node['uwsgi']['source_url'])
uwsgi_filepath = "#{Chef::Config['file_cache_path']}#{uwsgi_filename}"

remote_file uwsgi_filepath do
  source   "#{node['uwsgi']['source_url']}"
  owner    'root'
  group    'root'
  mode     '0644'
end

bash "extract_uwsgi" do
  action :run
  cwd ::File.dirname(uwsgi_filepath)
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  code <<-EOH
    mkdir /home/el/uwsgi_latest && tar xzvf #{uwsgi_filepath} -C /home/el/uwsgi_latest --strip-components 1
  EOH
  creates "/home/el/uwsgi_latest"
  notifies :create, "cookbook_file[buildconf/el.ini]", :immediately
  notifies :create, "cookbook_file[plugins/psgi/uwsgiplugin.py]", :immediately
  notifies :create, "cookbook_file[plugins/python/uwsgiplugin.py]", :immediately
end

cookbook_file "buildconf/el.ini" do
  source "/uwsgi_latest/buildconf/el.ini"
  path "/home/el/uwsgi_latest/buildconf/el.ini"
  owner    'el'
  group    'el'
  mode     '0775'
  action :nothing
end

cookbook_file "plugins/psgi/uwsgiplugin.py" do
  source "/uwsgi_latest/plugins/psgi/uwsgiplugin.py"
  path "/home/el/uwsgi_latest/plugins/psgi/uwsgiplugin.py"
  owner    'el'
  group    'el'
  mode     '0775'
  action :nothing
end

cookbook_file "plugins/python/uwsgiplugin.py" do
  source "/uwsgi_latest/plugins/python/uwsgiplugin.py"
  path "/home/el/uwsgi_latest/plugins/python/uwsgiplugin.py"
  owner    'el'
  group    'el'
  mode     '0775'
  action :nothing
end

execute "chown_el_home" do
  command "chown -Rf el:el /home/el"
end

bash "compile_uwsgi" do
  user "el"
  group "el"
  cwd "/home/el/uwsgi_latest"
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  code <<-EOH
    cd /home/el/uwsgi_latest
    source /home/el/.profile
    source /home/el/.bashrc
    perlbrew switch perl-5.18.2
    UWSGI_BIN_NAME=/var/local/EmpireLogistics/shared/local/bin/uwsgi UWSGI_FORCE_REBUILD=1 /var/local/EmpireLogistics/shared/python/bin/python uwsgiconfig.py --build el
  EOH
  creates "/var/local/EmpireLogistics/shared/local/bin/uwsgi"
  notifies :run, "bash[compile_psgi_plugin]", :immediately
  notifies :run, "bash[compile_python_plugin]", :immediately
  action :run
end

bash "compile_psgi_plugin" do
  user "el"
  group "el"
  cwd "/home/el/uwsgi_latest"
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  code <<-EOH
    cd /home/el/uwsgi_latest
    source /home/el/.profile
    source /home/el/.bashrc
    perlbrew switch perl-5.18.2
    /var/local/EmpireLogistics/shared/python/bin/python uwsgiconfig.py --plugin plugins/psgi el
  EOH
  creates "/var/local/EmpireLogistics/shared/local/uwsgi_plugins/psgi_plugin.so"
  action :run
end

bash "compile_python_plugin" do
  user "el"
  group "el"
  cwd "/home/el/uwsgi_latest"
  environment ({ 'HOME' => ::Dir.home(node['env']['user']), 'USER' => node['env']['user'], 'PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/local/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin:/var/local/EmpireLogistics/shared/python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PERLBREW_PERL' => 'perl-5.18.2', 'PERLBREW_ROOT' => '/var/local/EmpireLogistics/shared/perl', 'PERLBREW_HOME' => '/home/el/.perlbrew', 'PERLBREW_PATH' => '/var/local/EmpireLogistics/shared/perl/bin:/var/local/EmpireLogistics/shared/perl/perls/perl-5.18.2/bin' })
  code <<-EOH
    cd /home/el/uwsgi_latest
    source /home/el/.profile
    source /home/el/.bashrc
    perlbrew switch perl-5.18.2
    /var/local/EmpireLogistics/shared/python/bin/python uwsgiconfig.py --plugin plugins/python el
  EOH
  creates "/var/local/EmpireLogistics/shared/local/uwsgi_plugins/python_plugin.so"
  action :run
end

node["el"]["npm_packages"].each do |package|
  npm_package package do
    action :install
  end
end

cookbook_file "nginx.conf" do
  path "#{node["nginx"]["dir"]}/sites-enabled/empirelogistics"
  action :create
end

service "nginx" do
  action :restart
end

service "uwsgi" do
  provider Chef::Provider::Service::Upstart
  action :restart
end

cron "compress_tiles" do
  minute "0"
  hour "*"
  user "el"
  mailto "amiribarksdale@gmail.com"
  home "/home/el"
  command %Q{find /var/local/EmpireLogistics/shared/tiles -type f -name "*.json" -print0 | xargs -0r gzip -q -k}
end

cron "backup_database" do
  minute "0"
  hour "0"
  user "el"
  mailto "amiribarksdale@gmail.com"
  command %Q{
    vacuumdb -fz -U postgres empirelogistics >/dev/null 2>&1
    [ -d /var/local/EmpireLogistics/shared/backups/`date +%Y%W` ] || mkdir -p /var/local/EmpireLogistics/shared/backups/`date +%Y%W`
    pg_dump -U postgres -i -b empirelogistics | gzip > /var/local/EmpireLogistics/shared/backups/`date +%Y%W`/empirelogistics_`date +%Y%m%d`.gz
  }
end

cron "delete_old_backups" do
  minute "0"
  hour "0"
  weekday "1"
  user "el"
  mailto "amiribarksdale@gmail.com"
  command %Q{
    ls -t1 /var/local/EmpireLogistics/shared/backups/`date --date="- 1 week" +%Y%W` | tail -n +1 | xargs rm
  }
end
