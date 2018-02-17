property :domain, String
property :domain_name, String, name_property: true
property :filename, String

load_current_value do
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

attr_reader :subresource_rules

def initialize(*args)
  @subresource_rules = []
  super
end

def rule(name = nil, &block)
  @subresource_rules << [name, block]
end

action :create do
  seq = 0
  new_resource.subresource_rules.map do |sub_resource|
    sub_resource.run_context = new_resource.run_context
    sub_resource.run_action(:create)
  end
  new_resource.subresource_rules.each do |block|
    myname = block[0]
    code = block[1]
    # The resource used to be named after itself.  Instead now we'll just generate a generic name
    # Obviously it would be nicer to jump inside ulimit_rule and rename it, however that's
    # actually tricky to do while maintaining compatability
    if myname.nil?
      myname = "rule-#{seq}"
      seq += 1
    end
    ulimit_rule "#{new_resource.name}:#{myname}" do
      domain new_resource
      instance_eval &code
    end
  end

  new_resource.filename new_resource.name unless new_resource.filename
  new_resource.filename "#{new_resource.filename}.conf"
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
