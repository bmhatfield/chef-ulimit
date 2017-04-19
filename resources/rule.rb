class Chef::Resource::UlimitRule < Chef::Resource
  default_action :create

  property :type, kind_of: [Symbol, String], required: true
  property :item, kind_of: [Symbol, String], required: true
  property :value, kind_of: [String, Numeric], required: true
  property :domain, kind_of: [Chef::Resource, String], required: true

  action :create do
    new_resource.domain new_resource.domain.domain_name if new_resource.domain.is_a?(Chef::Resource)
    node.run_state[:ulimit] ||= Mash.new
    node.run_state[:ulimit][new_resource.domain] ||= Mash.new
    node.run_state[:ulimit][new_resource.domain][new_resource.item] ||= Mash.new
    node.run_state[:ulimit][new_resource.domain][new_resource.item][new_resource.type] = new_resource.value
    puts "Create: #{node.run_state[:ulimit].inspect}"
  end

  action :delete do
    # NOOP
  end
end
