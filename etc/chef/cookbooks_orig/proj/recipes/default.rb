proj_version = node['proj']['version']

# Ark keeps trying to create /usr/local/proj-4.8.0/proj-4.8.0
# then cd'ing to the wrong place,
# probably because the tarball contents are ./proj-4.8.0
# instead of proj-4.8.0.
# So we do it manually instead.
=begin
ark "proj" do
  url "http://download.osgeo.org/proj/proj-#{proj_version}.tar.gz"
  version proj_version
  action [:configure, :install_with_make]
  creates "/usr/local/proj-#{proj_version}"
end
=end



tarball = "proj-#{proj_version}.tar"
tarball_gz = "proj-#{proj_version}.tar.gz"
remote_file "/tmp/#{tarball}" do
  source "http://download.osgeo.org/proj/#{tarball_gz}"
  mode "0644"
  action :create_if_missing
end

bash "install_proj_#{proj_version}" do
  untar_dir = "/usr/local/src"
  user "root"
  code <<-EOH
    cd #{untar_dir} && \
    tar xzvf /tmp/#{tarball} && \
    cd proj-#{proj_version} && \
    ./configure && make && make install && \
    ldconfig
  EOH
  command ""
  creates untar_dir + "/proj-#{proj_version}"
  action :run
end
