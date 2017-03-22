class Chef::Resource::UlimitRule < Chef::Resource
  actions :create, :delete
  default_action :create

  attribute :type, :kind_of => [Symbol,String], :required => true
  attribute :item, :kind_of => [Symbol,String], :required => true
  attribute :value, :kind_of => [String,Numeric], :required => true
  attribute :domain, :kind_of => [Chef::Resource, String], :required => true


  def load_current_resource
    new_resource.domain new_resource.domain.domain_name if new_resource.domain.is_a?(Chef::Resource)
    node.run_state[:ulimit] ||= Mash.new
    node.run_state[:ulimit][new_resource.domain] ||= Mash.new
  end

  action :create do
    node.run_state[:ulimit][new_resource.domain][new_resource.item] ||= Mash.new
    node.run_state[:ulimit][new_resource.domain][new_resource.item][new_resource.type] = new_resource.value
  end

  action :delete do
    # NOOP
  end
end
