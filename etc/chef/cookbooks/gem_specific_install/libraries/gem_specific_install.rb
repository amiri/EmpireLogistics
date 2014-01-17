
require 'chef/provider/package/rubygems'
class Chef::Provider::Package::Rubygems::SpecificInstall < Chef::Provider::Package::Rubygems

  def action_install
    options = @new_resource.options
    cmd = "#{gem_binary_path} specific_install #{@new_resource.package_name} -l #{options[:repo]}"
    cmd << " -b #{options[:branch]}" if options[:branch]
    logger.debug { "use #{cmd} to install"}
    shell_out!(cmd, :env=>nil)
  end

  def candidate_version
    logger.debug {"candidate_version not implement"}
    return "0.0.0"
  end
end
