
module TicketMaster::Provider
  module Zendesk

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      API = ZendeskAPI::Ticket
      USER_API = ZendeskAPI::User

      def initialize(*object)
        return super(object.first) if object.first.is_a? Hash 
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

      def created_at
        Time.parse(self[:created_at])
      end

      def updated_at
        Time.parse(self[:updated_at])
      end

      def self.find(project_id, *options)
        tickets = self.find_all(project_id)
        if options[0].first.is_a? Array
          Ticket.find_all(self.name).select { |ticket| ticket if options[0].first.any? { |ticket_id| ticket_id == ticket.id }}
        elsif options[0].first.is_a? Hash
          Ticket.find_by_attributes(self.name, options[0].first)
        else
          tickets
        end
      end

      def self.find_all(*options)
        project_id = options.first
        SEARCH_API.find(:all, :params => {:query => "status:open"}).collect do |ticket| 
          ticket.requester_id = requestor(ticket)
          ticket.assignee_id = assignee(ticket)
          self.new([ticket, project_id])
        end
      end

      def self.find_by_id(project_id, ticket_id)
        self.new [API.find(ticket_id), project_id]
      end

      def self.find_by_attributes(project_id, attributes = {})
        search_by_attribute(self.find_all(project_id), attributes)
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

      private
      def self.requestor(ticket)
        USER_API.find(ticket.requester_id).email
      end

      def self.assignee(ticket)
        USER_API.find(ticket.assignee_id).email
      end

    end

  end
end
