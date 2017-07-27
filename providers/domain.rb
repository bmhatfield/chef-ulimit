require_relative 'rule'

class Chef::Provider::UlimitDomain < Chef::Provider
  use_inline_resources

  def load_current_resource
    new_resource.filename new_resource.name unless new_resource.filename
    new_resource.filename "#{new_resource.filename}.conf"

    new_resource.subresource_rules.map! do |name, block|
      urule = Chef::Resource::UlimitRule.new("ulimit_rule[#{new_resource.name}:#{name}]", nil)
      urule.domain new_resource
      urule.action :nothing
      urule.instance_eval(&block)
      unless name
        urule.name "ulimit_rule[#{new_resource.name}:#{urule.item}-#{urule.type}-#{urule.value}]"
      end
      urule
    end
  end

  action :create do
    new_resource.subresource_rules.map do |sub_resource|
      sub_resource.run_context = new_resource.run_context
      sub_resource.run_action(:create)
    end

    template ::File.join(node['ulimit']['security_limits_directory'], new_resource.filename) do
      source 'domain.erb'
      cookbook 'ulimit'
      variables domain: new_resource.domain_name
    end
  end

  action :delete do
    file ::File.join(node['ulimit']['security_limits_directory'], new_resource.filename) do
      action :delete
    end
  end
end
