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
      @zendesk = ::Zendesk::Main.new(auth.subdomain || auth.account, auth.username, auth.password)
    end
	
  end
end
