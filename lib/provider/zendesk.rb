require 'taskmapper'
module TaskMapper::Provider
  # This is the Zendesk Provider for taskmapper
  module Zendesk
    include TaskMapper::Provider::Base
    #PROJECT_API = ZendeskAPI::Organization

    class << self
      attr_accessor :api
    end

    # This is for cases when you want to instantiate using TaskMapper::Provider::Yoursystem.new(auth)
    def self.new(auth = {})
      TaskMapper.new(:zendesk, auth)
    end

    # The authorize and initializer for this provider
    def authorize(auth = {})
      @authentication ||= TaskMapper::Authenticator.new(auth)
      auth = @authentication
      if (auth.account.nil? and auth.username.nil? and auth.password.nil?)
        raise "Please provide at least an url (subdomain), username and password)"
      end
      TaskMapper::Provider::Zendesk.api = ZendeskAPI::Client.new do |config|
        config.url = "https://#{auth.account}.zendesk.com/api/v2/"
        config.username = auth.username
        config.password = auth.password
      end
    end

    def projects(*options)
      [Project.new({:account => @authentication.account, :username => @authentication.username, :name => "#{@authentication.account}-project"})]
    end

    def project(*options)
      unless options.empty?
        Project.new({:account => @authentication.account, :username => @authentication.username, :name => "#{@authentication.account}-project"})
      else
        TaskMapper::Provider::Zendesk::Project
      end
    end

    def valid?
      begin
        !ZendeskAPI::Search.find(:first, :params => {:query => "status:open"}).nil?
      rescue
        false
      end
    end
  end
end
