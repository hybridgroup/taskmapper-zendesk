require 'rubygems'
require 'active_support'
require 'active_resource'

module ZendeskAPI
  class Error < StandardError; end

  class << self

    def authenticate(account, username, password)
      @username = username
      @password = password
      self::Base.user = username
      self::Base.password = password
      self::Base.site = "http://#{account}.zendesk.com"
    end

    def resources
      @resources ||= []
    end

  end

  class Base < ActiveResource::Base
    self.format = :json
    def self.inherited(base)
      ZendeskAPI.resources << base
      super
    end
  end

  class Request < Base
  end

end
