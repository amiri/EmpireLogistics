actions :configure, :install, :remove
default_action :configure

attribute :path, :name_attribute => true, :kind_of => String, :required => true
attribute :parameters, :kind_of => Hash, :required => true
attribute :separator, :kind_of => String
attribute :comment, :kind_of => String

attr_accessor :installed, :configured
