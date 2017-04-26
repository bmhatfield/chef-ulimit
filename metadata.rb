maintainer       'Brian Hatfield'
maintainer_email 'bmhatfield@gmail.com'
license          'Apache-2.0'
description      'Installs/Configures ulimit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name             'ulimit'
version          '0.5.0'

supports         'debian'
supports         'ubuntu'

source_url 'https://github.com/bmhatfield/chef-ulimit'
issues_url 'https://github.com/bmhatfield/chef-ulimit/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
