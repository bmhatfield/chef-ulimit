attr_reader :subresource_rules

def initialize(*args)
  @subresource_rules = []
  super
end

actions :create, :delete
default_action :create

attribute :domain_name, :kind_of => String, :name_attribute => true
attribute :filename, :kind_of => String

def rule(name=nil, &block)
  @subresource_rules << [name, block]
end
