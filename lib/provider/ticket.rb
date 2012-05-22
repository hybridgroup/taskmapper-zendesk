
module TaskMapper::Provider
  module Zendesk

    class Ticket < TaskMapper::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      API = ZendeskAPI::Ticket
      USER_API = ZendeskAPI::User

      def initialize(*object) 
        @system_data = {}
        @cache = {}
        first = object.shift
        case first 
        when Hash
          super first.to_hash
        else
          @system_data[:client] = first
          super first.attributes
        end
      end

      def created_at
        Time.parse(self[:created_at])
      end

      def updated_at
        Time.parse(self[:updated_at])
      end

      def comments(*options)
        Comment.find(project_id, id, options)
      end

      def comment(*options)
        if options.first.is_a? Fixnum
          Comment.find(project_id, id, [options.first]).first
        elsif options.first.is_a? Hash
          Comment.find_by_attributes(project_id, id, options.first).first
        end
      end

      class << self
        def find_all(project_id)
          SEARCH_API.find(:all, :params => {:query => "status:open"}).collect do |ticket| 
            ticket.requester_id = requestor(ticket)
            ticket.assignee_id = assignee(ticket)
            self.new ticket.attributes.merge! :project_id => project_id
          end
        end

        def find_by_id(project_id, ticket_id)
          self.new zendesk_ticket(ticket_id).attributes.merge! :project_id => project_id
        end

        def find_by_attributes(project_id, attributes = {})
          search_by_attribute(self.find_all(project_id), attributes)
        end

        private
        def requestor(ticket)
          USER_API.find(ticket.requester_id).email
        end

        def assignee(ticket)
          USER_API.find(ticket.assignee_id).email
        end

        def zendesk_ticket(ticket_id)
          API.find ticket_id
        end
      end

    end
  end
end
