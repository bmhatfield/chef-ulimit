class Chef::Resource::UlimitDomain < Chef::Resource
  attr_reader :subresource_rules

  def initialize(*args)
    @subresource_rules = []
    super
  end

  default_action :create

  property :domain, kind_of: [Chef::Resource::UlimitDomain, String]
  property :domain_name, kind_of: String, name_property: true
  property :filename, kind_of: String

  def rule(name = nil, &block)
    @subresource_rules << [name, block]
  end

  action :create do
    seq = 0
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
end
