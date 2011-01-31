require 'rubygems'
require 'active_support'
require 'active_resource'

module ActiveResource
  module Formats
    module XmlFormat
      extend self

      def decode(xml)
        Nokogiri::XML(xml)
      end
    end
  end
end

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
    self.format = :xml
    def self.inherited(base)
      ZendeskAPI.resources << base
    end
  end

  class Search < Base

    def self.collection_path(prefix_options = {}, query_options = nil) 
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}search.#{format.extension}#{query_string(query_options)}"
    end

  end

end
