use_inline_resources

include Chef::DSL::IncludeRecipe

action :configure do
  include_recipe "conffile"

  ruby_block "Configure #{current_resource.name}" do
    block do
      Ini.new( init_hash ).merge(new_resource.parameters).write
    end
    not_if { current_resource.configured }
  end
end

action :install do
  include_recipe "conffile"
  ruby_block "Install #{current_resource.name}" do
    block do
      Ini.new( init_hash.merge( :content => new_resource.parameters) ).write
    end
    not_if { current_resource.installed }
  end
end

action :remove do
  file current_resource.path do
    action :delete
  end
end

def load_current_resource
  require 'ini-phile'

  @current_resource = Chef::Resource::ConffileIni.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.parameters(@new_resource.parameters)
  if ini_equal?(@current_resource.parameters)
    @current_resource.installed = true
    @current_resource.configured = true
  elsif ini_include?(@current_resource.parameters)
    @current_resource.configured = true
  end
end

def init_hash
  init = { :filename => new_resource.path }
  init.merge( :comment => new_resource.comment) if new_resource.comment
  init.merge( :param => new_resource.separator) if new_resource.separator
  return init
end

def ini_equal?(parameters)
  if ::File.exists?(new_resource.path)
    current_ini = Ini.new(init_hash)
    return true if current_ini.to_h == parameters
  end
  return false
end

def ini_include?(parameters)
  if ::File.exists?(new_resource.path)
    current_ini = Ini.new(init_hash)
    return true if current_ini.to_h.merge(parameters) == current_ini
  end
  return false
end
