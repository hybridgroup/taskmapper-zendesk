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
      self::Base.site = "https://#{account}.zendesk.com/api/v1/"
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

  class Search < Base
    def self.collection_path(prefix_options = {}, query_options = nil) 
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}search.#{format.extension}#{query_string(query_options)}"
    end

    def self.element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}search.#{format.extension}#{query_string(query_options)}"
    end
  end

  class Ticket < Base
  end

  class Request < Base
  end

  class User < Base
  end

end
