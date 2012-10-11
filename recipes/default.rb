# Cookbook Name:: ulimit
# Recipe:: default
#
# Copyright 2012, Brightcove, Inc
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
  when "debian", "ubuntu"
    template "/etc/pam.d/su"
end
