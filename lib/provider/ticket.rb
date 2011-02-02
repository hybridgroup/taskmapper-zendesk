
module TicketMaster::Provider
  module Zendesk

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      API = ZendeskAPI::Ticket

      def initialize(*object)
        if object.first 
          args = object.first
          object = args.shift
          project_id = args.shift
          @system_data = {:client => object}
          unless object.is_a? Hash
            hash = {:id => object.nice_id,
                    :status => object.status_id,
                    :title => object.subject,
                    :created_at => object.created_at,
                    :updated_at => object.updated_at,
                    :description => object.description,
                    :assignee => object.assignee_id,
                    :requestor => object.requester_id,
                    :priority => object.priority_id,
                    :project_id => project_id}
          else
            hash = object
          end
          super hash
        end
      end

      def self.find_all(*options)
        project_id = options.first
        SEARCH_API.find(:all, :params => {:query => "status:open"}).collect { |ticket| self.new [ticket, project_id]}
      end

      def self.find_by_id(*options)
        id = options.shift
        project_id = options.shift
        self.new [API.find(id), project_id]
      end

    end

  end
end
