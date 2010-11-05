require 'rubygems'
require 'ticketmaster'
require 'active_support'
require 'active_resource'

# Ruby lib for working with the Zendesk API's XML interface.  
# The first thing you need to set is the account name.  This is the same
# as the web address for your account.
#
#   ZendeskAPI.account = 'activereload'
#
# Then, you should set the authentication.  
#
#   # with basic authentication
#   ZendeskAPI.authenticate('rick@techno-weenie.net', 'spacemonkey')
#
#
# This library is a small wrapper around the REST interface.  You should read the docs at
# http://www.zendesk.com/api/
#


module ZendeskAPI

  class Error < StandardError; end
  class << self
    attr_accessor :email, :password, :host_format, :domain_format, :protocol, :port
    attr_reader :account

    # Sets the account name, and updates all the resources with the new domain.
    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format % name, ":#{port}"])
      end
      @account = name
    end

    # Sets up basic authentication credentials for all the resources.
    def authenticate(email, password)
      @email    = email
      @password = password
      self::Base.user = email
      self::Base.password = password
    end

    def resources
      @resources ||= []
    end
  end
  
  self.host_format   = '%s://%s%s'
  self.domain_format = '%s.zendesk.com'
  self.protocol      = 'http'
  self.port          = ''

  class Base < ActiveResource::Base
   # class << self
    def self.inherited(base)
      ZendeskAPI.resources << base
      class << base
        attr_accessor :site_format
      end
      base.site_format = '%s'
      super
    end

  end
  
  # Finding tickets
  # 
  #   ticket = ZendeskAPI::Ticket.find(44)
  #
  
  class Group < Base
  end
  
  class Organization < Base
  end
  
  class User < Base
    def user_identities
	  UserIdentity.all(:params => {:user_id => self.id})
	end
  end
  
  class Ticket < Base
    def self.find_all_by_view(view_id)
	  Rule.find(view_id)
	end 
  end 
  
  class Tag < Base
    def save
      raise Error, "Tags must be associated with some ticket"
    end
  end
  
  class Rule < Base
  end

  class Search < Base
    self.collection_name = "search"
  end
  
  class UserIdentity < Base
    site_format << '/users/:user_id'
  end
  
end


