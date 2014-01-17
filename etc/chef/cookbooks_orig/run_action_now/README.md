# run_action_now cookbook

Cookbook for Opscode Chef.

http://community.opscode.com/cookbooks/run_action_now


# Description

Allows for immediate one-time execution of Chef resources without bulky syntax. Traditionally to run a resource
during convergence you would have to set the action to :nothing, and then use the `.run_action` method with the
real action you wanted. This cookbook adds the `.run_action_now` method which looks up the desired action(s) from
the resource itself, and then sets the action to :nothing automatically.

**PLEASE NOTE**

When appropriate you should consider the `use_inline_resources` to perform this functionality globally within a
LWRP. Please see the [Chef docs here](http://docs.opscode.com/lwrp_custom_provider.html#use-inline-resources) for
more information.


# Usage

Directly on a resource block:

    directory "/tmp/alpha" do
      action :create
      mode 0777
    end.run_action_now

    (directory "/tmp/beta").run_action_now    # without a block

    service "sshd" do
      action [ :enable, :start ]              # with multiple actions
    end.run_action_now

As a mixin function:

    include Chef::Provider::ServiceFactory::Mixin::Unix

    run_action_now((
      directory "/tmp/charlie" do
        action :create
      end
    ))  # note the double parenthesis above and below


# Recipes

This cookbook only provides library enhancements, no recipes are included.


# Development and Maintenance

* Found a bug?
* Need some help?
* Have a suggestion?
* Want to contribute?

Please visit: [code.binbab.org](http://code.binbab.org)


# Authors and License

  * Author:: BinaryBabel OSS (<projects@binarybabel.org>)
  * Copyright:: 2013 `sha1(OWNER) = df334a7237f10846a0ca302bd323e35ee1463931`
  * License:: Apache License, Version 2.0

----

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
