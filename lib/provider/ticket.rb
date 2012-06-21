module TaskMapper::Provider
  module Zendesk
    class Ticket < TaskMapper::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      ZENDESK_USER = ZendeskAPI::User

      def initialize(*args) 
        case args.first
        when Hash then super args.first
        end
      end

      def comments(*options)
        fail "Not supported by Zendesk API"
        []
      end

      def comment(*options)
        fail "Not supported by Zendesk API"
        nil
      end

      def title
        self.subject
      end

      def created_at
        format_date self[:created_at]
      end

      def updated_at
        format_date self[:updated_at]
      end

      class << self
        def search(project_id)
          TaskMapper::Provider::Zendesk.api.tickets.collect do |ticket|
            self.new ticket.merge! :project_id => project_id
          end
        end

        def find_by_id(project_id, ticket_id)
          self.new zendesk_ticket(ticket_id).attributes.merge! :project_id => project_id
        end

        def find_by_attributes(project_id, attributes = {})
          search_by_attribute(self.search(project_id), attributes)
        end

        def create(options)
          self.new create_zendesk_ticket(options)
        end

        private
        def create_zendesk_ticket(options)
          #ticket = API.new translate options, {:title => :description}
          #ticket.save
          #ticket
        end

        def requestor(ticket)
          ZENDESK_USER.find(ticket.requester_id).email
        end

        def assignee(ticket)
          ZENDESK_USER.find(ticket.assignee_id).email
        end

        def zendesk_ticket(ticket_id)
          TaskMapper::Provider::Zendesk.api.tickets.find :id => ticket_id
        end

        def translate(hash, mapping) 
          Hash[hash.map { |k, v| [mapping[k] ||= k, v]}]
        end
      end

      private
      def format_date(date) 
        begin
          Time.parse(date)
        rescue
          date
        end
      end
    end
  end
end
