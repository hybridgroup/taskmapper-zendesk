module TaskMapper::Provider
  module Zendesk
    class Ticket < TaskMapper::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      API = ZendeskAPI::Ticket
      ZENDESK_USER = ZendeskAPI::User

      def initialize(*args) 
        case args.first
        when Hash then super args.first
        else raise ArgumentError.new
        end
      end

      def id 
        self.nice_id
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

      def save 
        if to_zendesk_ticket.new? 
          puts "aqui"
          to_zendesk_ticket.save 
        else 
          update
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

      def to_zendesk_ticket
        API.new.update_with(self)
      end

      class << self
        def search(project_id)
          SEARCH_API.find(:all, :params => {:query => "status:open"}).collect do |ticket| 
            ticket.requestor = requestor(ticket)
            ticket.assignee = assignee(ticket)
            self.new ticket.attributes.merge! :project_id => project_id
          end
        end

        def find_by_id(project_id, ticket_id)
          self.new zendesk_ticket(ticket_id).attributes.merge! :project_id => project_id
        end

        def find_by_attributes(project_id, attributes = {})
          search_by_attribute(self.search(project_id), attributes)
        end

        def create(attributes)
          ticket = self.new attributes
          ticket if ticket.save
        end

        private
        def requestor(ticket)
          ZENDESK_USER.find(ticket.requester_id).email
        end

        def assignee(ticket)
          ZENDESK_USER.find(ticket.assignee_id).email
        end

        def zendesk_ticket(ticket_id)
          API.find ticket_id
        end

        def translate(hash, mapping) 
          Hash[hash.map { |k, v| [mapping[k] ||= k, v]}]
        end
      end

    end

    class Net::HTTP
      def send(*args)
        p "<<sending #{args.inspect}"
        r = super *args
        p "<<response #{r.inspect}"
        r
      end
    end
  end
end
