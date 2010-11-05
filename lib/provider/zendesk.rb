require 'ticketmaster'
module TicketMaster::Provider
  # This is the Zendesk Provider for ticketmaster
  module Zendesk
    include TicketMaster::Provider::Base
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Yoursystem.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:zendesk, auth)
    end
    
    # The authorize and initializer for this provider
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      auth = @authentication
      if auth.account.nil? or (auth.token.nil? and (auth.username.nil? and auth.password.nil?))
        raise "Please provide at least an account (subdomain) and token or username and password)"
      end
      ZendeskAPI.account = auth.account || auth.subdomain
      if auth.token
        ZendeskAPI.token = auth.token
      elsif auth.username && auth.password
        ZendeskAPI.authenticate(auth.username, auth.password)
      end
    end
	
	# The projects
    #
    # We have to merge in the auth information because, due to the class-based authentication
    # mechanism, if we don't reset the authorize information for every request, it would 
    # end up using whatever the previous instantiated object's account info is.
    def projects(*options)
      authorize
      super(*options)
    end
    
    # The project
    def project(*options)
      authorize
      super(*options)
    end
    
    # The tickets
    #
    # Due to the nature of lighthouse, we must have the project_id to pull tickets. You can
    # pass in the id through this format:
    # 
    #    .tickets(22)
    #    .tickets(:project_id => 22)
    # 
    # To conform to ticketmaster's standard of returning all tickets on a call to this method
    # without any parameters, if no parameters are passed, it will return all tickets for whatever
    # the first project is.
    def tickets(*options)
      authorize
      super(*options)
    end
    
    # the ticket
    def ticket(*options)
      authorize
      super(*options)
    end
    
  end
end
