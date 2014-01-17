#
# Library:: run_action_now
#
# Author:: BinaryBabel OSS (<projects@binarybabel.org>)
# Homepage:: http://www.binarybabel.org
# License:: Apache License, Version 2.0
#
# For bugs, docs, updates:
#
#     http://code.binbab.org
#
# Copyright 2013 sha1(OWNER) = df334a7237f10846a0ca302bd323e35ee1463931
#  
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#  
#     http://www.apache.org/licenses/LICENSE-2.0
#  
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module RunActionNow
  module Mixin

    def run_action_now(resource=nil)
      resource ||= self
      actions = Array(resource.action)
      Chef::Log.debug("RUN_ACTION_NOW :: Running actions for resource. #{resource.name} #{actions}")
      resource.action(:nothing)
      actions.each do |action|
        resource.run_action(action)
      end
    end

  end
end

unless Chef::Resource.method_defined?(:run_action_now)
  Chef::Resource.send(:include, ::RunActionNow::Mixin)
end
