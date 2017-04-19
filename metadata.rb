maintainer       "Brian Hatfield"
maintainer_email "bmhatfield@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures ulimit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             "ulimit"
version          "0.5.0"

supports         'debian'
supports         'ubuntu'

source_url 'https://github.com/bmhatfield/chef-ulimit' if respond_to?(:source_url)
issues_url 'https://github.com/bmhatfield/chef-ulimit/issues' if respond_to?(:issues_url)
chef_version '>= 11' if respond_to?(:chef_version)
