Description
===========

This is a short-and-simple cookbook to provide a user_ulimit resource for overriding various ulimit settings. It places configured templates into /etc/security/limits.d/, named for the user the ulimit applies to.

It also provides a helper recipe (default.rb) for allowing ulimit overrides with the 'su' command on Ubuntu, which is disabled by default for some reason.

Requirements
============

Add to your repo, then depend upon this cookbook from wherever you need to override ulimits.

Attributes
==========

* `node['ulimit']['pam_su_template_cookbook']` - Defaults to nil (current cookbook).  Determines what cookbook the su pam.d template is taken from
* `node['ulimit']['users']` - Defaults to empty Hash.  List of users with their limits

Usage
=====

Consume the user_ulimit resource like so:

    user_ulimit "tomcat" do
      filehandle_limit 8192 # optional
      process_limit 61504 # optional
      memory_limit 1024 # optional
      core_limit 2048 # optional
    end

You can also define limits using attributes on roles or nodes:

    "default_attributes": {
        "ulimit": {
            "users": {
                "tomcat": {
                    "filehandle_limit": 8193,
                    "process_limit": 61504
                },
                "hbase": {
                    "filehandle_limit": 32768
                }
            }
        }
    }
