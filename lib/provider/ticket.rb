module TaskMapper::Provider
  module Zendesk
    class Ticket < TaskMapper::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      API = ZendeskAPI::Ticket
      
      def initialize(*args) 
        ticket = args.first
        case ticket
        when Hash then super ticket
        when ZendeskAPI::Ticket then super ticket.to_ticket_hash
        else raise ArgumentError.new
        end
      end

      def id 
        self[:nice_id]
      end

      # FIXME: This is kinda ugly
      def title
        self[:subject].nil? ? self[:title] : self[:subject]
      end

      def created_at
        format_date self[:created_at]
      end

      def updated_at
        format_date self[:updated_at]
      end

      def new?
        id.nil?
      end

      def save 
        if new? 
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

      def find_zendesk_ticket
        t = API.find id 
        raise TaskMapper::Exception.new "Ticket with #{id} not found" unless t
        t
      end

      def update
        find_zendesk_ticket.update_with(self).save
      end

      class << self
        def search(project_id)
          SEARCH_API.find(:all, :params => {:query => "status:open"}).collect do |ticket| 
            self.new ticket.attributes.merge! :project_id => project_id
          end
        end

        def find_by_id(project_id, ticket_id)
          self.new API.find(ticket_id).attributes.merge! :project_id => project_id
        end

        def find_by_attributes(project_id, attributes = {})
          search_by_attribute(self.search(project_id), attributes)
        end

        def create(attributes)
          ticket = self.new attributes
          ticket if ticket.save
        end
      end

    end
  end
end
