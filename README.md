Description
===========

This is a short-and-simple cookbook to provide a user_ulimit resource for overriding various ulimit settings. It places configured templates into /etc/security/limits.d/, named for the user the ulimit applies to.

It also provides a helper recipe (default.rb) for allowing ulimit overrides with the 'su' command on Ubuntu, which is disabled by default for some reason.

Requirements
============

Add to your repo, then depend upon this cookbook from wherever you need to override ulimits.

Attributes
==========

None.

Usage
=====

Consume the user_ulimit resource like so:

    user_ulimit "tomcat" do
      filehandle_limit 8192
      process_limit 61504
    end

