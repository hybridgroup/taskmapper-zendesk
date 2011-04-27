
module TicketMaster::Provider
  module Zendesk

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here

      SEARCH_API = ZendeskAPI::Search
      API = ZendeskAPI::Ticket

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

      def self.find_all(*options)
        project_id = options.first
        SEARCH_API.find(:all, :params => {:query => "status:open"}).collect { |ticket| self.new([ticket, project_id])}
      end

      def self.find_by_id(project_id, ticket_id)
        self.new [API.find(ticket_id), project_id]
      end

      def self.find_by_attributes(project_id, attributes = {})
        tickets = self.find_all(project_id)
        search_by_attribute(tickets, attributes)
      end

      def comments(*options)
        Comment.find(project_id, id, options)
      end

      def comment(*options)
        unless options.first.is_a? Hash
          ticket_comments.select { |comment| comment.id == options.first }.first
        else
          comments_find_by_attributes(options.first).first
        end
      end

      private 
      def ticket_comments
        Comment.find_all(self[:project_id], self[:id])
      end

      def comments_find_by_attributes(attributes)
        Comment.find_by_attributes(self[:project_id], self[:id], attributes)
      end

    end

  end
end
