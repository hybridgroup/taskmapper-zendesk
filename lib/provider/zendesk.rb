require 'ticketmaster'
module TicketMaster::Provider
  # This is the Zendesk Provider for ticketmaster
  module Zendesk
    include TicketMaster::Provider::Base
    #PROJECT_API = ZendeskAPI::Organization
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Yoursystem.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:zendesk, auth)
    end
    
    # The authorize and initializer for this provider
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      auth = @authentication
      if (auth.account.nil? and auth.username.nil? and auth.password.nil?)
        raise "Please provide at least an url (subdomain), username and password)"
      end
      ZendeskAPI.authenticate(auth.account, auth.username, auth.password)
    end

    def projects(*options)
      [Project.new({:account => @authentication.account, :username => @authentication.username, :name => "#{@authentication.account}-project"})]
    end

    def project(*options)
      unless options.empty?
        Project.new({:account => @authentication.account, :username => @authentication.username, :name => "#{@authentication.account}-project"})
      else
        TicketMaster::Provider::Zendesk::Project
      end
    end

    def valid?
        ZendeskAPI::Search.find(:first, :params => {:query => "status:open"})
    end

  end
end
