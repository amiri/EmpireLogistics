# gem_specific_install cookbook

# Requirements

## Cookbooks

* git
* run_action_now

# Usage

```
include_recipe "gem_specific_install"
chef_gem "inifile" do
  provider Chef::Provider::Package::Rubygems::SpecificInstall
  options( :repo => "https://github.com/optiflows/inifile.git")
end
```

```
include_recipe "gem_specific_install"
gem_package "inifile" do
  provider Chef::Provider::Package::Rubygems::SpecificInstall
  options( :repo => "https://github.com/optiflows/inifile.git", :branch => "master)
end
```

# Attributes

# Recipes

# Author

Author:: Guilhem Lettron (<guilhem.lettron@optiflows.com>)
