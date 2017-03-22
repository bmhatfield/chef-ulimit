require_relative 'rule'

class Chef::Resource::UlimitDomain < Chef::Resource
  attr_reader :subresource_rules

  def initialize(*args)
    @subresource_rules = []
    super
  end

  def load_current_resource
    # do full type check
    valid_types = [Chef::Resource::UlimitDomain, String]
    unless(valid_types.include?(new_resource.domain.class))
      raise TypeError.new(
        "Expecting `domain` attribute to be of type: #{valid_types.map(&:to_s).join(', ')}. " <<
        "Got: #{new_resource.domain.class}"
      )
    end
  end

  default_action :create

  attribute :domain_name, :kind_of => String, :name_attribute => true
  attribute :filename, :kind_of => String

  def rule(name=nil, &block)
    @subresource_rules << [name, block]
  end


  def load_current_resource
    new_resource.filename new_resource.name unless new_resource.filename
    new_resource.filename "#{new_resource.filename}.conf"

    new_resource.subresource_rules.map! do |name, block|
      urule = Chef::Resource::UlimitRule.new("ulimit_rule[#{new_resource.name}:#{name}]", nil)
      urule.domain new_resource
      urule.action :nothing
      urule.instance_eval(&block)
      unless(name)
        urule.name "ulimit_rule[#{new_resource.name}:#{urule.item}-#{urule.type}-#{urule.value}]"
      end
      urule
    end
  end

  action :create do
    use_inline_resources if self.respond_to?(:use_inline_resources)

    new_resource.subresource_rules.map do |sub_resource|
      sub_resource.run_context = new_resource.run_context
      sub_resource.run_action(:create)
    end

    utemplate = template ::File.join(node['ulimit']['security_limits_directory'], new_resource.filename) do
      source 'domain.erb'
      cookbook 'ulimit'
      variables :domain => new_resource.domain_name
    end

    unless(self.respond_to?(:use_inline_resources))
      new_resource.updated_by_last_action(utemplate.updated_by_last_action?)
    end
    
  end

  action :delete do
    use_inline_resources if self.respond_to?(:use_inline_resources)
    ufile = file ::File.join(node['ulimit']['security_limits_directory'], new_resource.filename) do
      action :delete
    end

    unless(self.respond_to?(:use_inline_resources))
      new_resource.updated_by_last_action(ufile.updated_by_last_action?)
    end
  end
end
