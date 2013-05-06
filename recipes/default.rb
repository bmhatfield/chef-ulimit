# Cookbook Name:: ulimit
# Recipe:: default
#
# Copyright 2012, Brightcove, Inc
#
# All rights reserved - Do Not Redistribute
#
ulimit = node['ulimit']

case node[:platform]
  when "debian", "ubuntu"
    template "/etc/pam.d/su" do
      cookbook ulimit['pam_su_template_cookbook']
    end
end

ulimit['users'].each do |user, attributes|
  user_ulimit user do
    attributes.each do |a, v|
      send(a.to_sym, v)
    end
  end
end
