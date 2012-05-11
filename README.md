# taskmapper-redmine

This is a provider for [taskmapper](http://ticketrb.com). It provides interoperability with [Zendesk](http://www.zendesk.com) and it's issue tracking system through the taskmapper gem.

Right now this provider only supports reading operations.

# Usage and Examples

First we have to instantiate a new taskmapper instance:

    zendesk = taskmapper.new(:zendesk, {:account => 'hybridgroup', :username => "foo", :password => "bar"})

If you do not pass in account, username and password, you won't get any information.

## Finding Projects

You can find your own projects by doing:

    projects = zendesk.projects # Will return all your repositories
    projects = zendesk.projects(['your_repo1']) # You must use your projects identifier 
    project = zendesk.project('your_repo') # Also use project identifier in here

Note: Zendesk dosen't support a projects which means this is a taskmapper place holder object, you will always get the same project name as follows: 'accountname-project'.

	
## Finding Tickets

    tickets = project.tickets # All open issues
    tickets = project.tickets([1,2]) # An array of tickets with the specified id's
    ticket = project.ticket(<issue_number>)

## Finding Comments
    
    comments = tickets.comments
    comments = tickets.comments([1,2]) # An array of comments with the specified id's


## Requirements

* rubygems (obviously)
* taskmapper gem (latest version preferred)
* jeweler gem (only if you want to repackage and develop)

The taskmapper gem should automatically be installed during the installation of this gem if it is not already installed.

## Other Notes

Since this and the taskmapper gem is still primarily a work-in-progress, minor changes may be incompatible with previous versions. Please be careful about using and updating this gem in production.

If you see or find any issues, feel free to open up an issue report.


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so we don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself so we can ignore when I pull)
* Send us a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 The Hybrid Group. See LICENSE for details.


