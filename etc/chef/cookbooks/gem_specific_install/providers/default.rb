use_inline_resources

include Chef::DSL::IncludeRecipe

action :install do
  include_recipe "gem_specific_install"

  git path do
    repository new_resource.repository
    revision new_resource.revision if new_resource.revision
#    notifies :create, "ruby_block[install gem #{new_resource.gemname}]", :immediately
  end

  ruby_block "install gem #{new_resource.gemname}" do
    block do
      require 'rubygems/dependency_installer'
      require 'rubygems/specification'
      require 'rubygems/builder'

      ::Dir.chdir(path)
      gemspec = ::Gem::Specification.load(gemspec_file)
      gem = ::Gem::Builder.new(gemspec).build
      inst = ::Gem::DependencyInstaller.new
      inst.install gem
      Gem.clear_paths
    end
    action :create
    only_if { ::File.exists?(gemspec_file) }
  end
end

def path
  ::File.join(Chef::Config[:file_cache_path], new_resource.gemname)
end

def gemspec_file
  ::File.join(path, "#{new_resource.gemname}.gemspec")
end

