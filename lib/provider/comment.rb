module TicketMaster::Provider
  module Zendesk
    # The comment class for ticketmaster-zendesk
    #
    # Do any mapping between Ticketmaster and your system's comment model here
    # versions of the ticket.
    #
    class Comment < TicketMaster::Provider::Base::Comment
      # declare needed overloaded methods here
      
      USER_API = ZendeskAPI::User

      def initialize(*object)
        return super(object.first) if object.first.is_a? Hash 
        if object.first
          object = object.first
          ticket_id = object.shift
          project_id = object.shift
          comment_id = object.shift
          object = object.shift
          @system_data = {:client => object}
          unless object.is_a? Hash
            hash = {:author => object.author_id,
                    :body => object.value,
                    :id => comment_id,
                    :created_at => object.created_at,
                    :updated_at => object.created_at,
                    :ticket_id => ticket_id,
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

      def self.find(project_id, ticket_id, *options)
        ticket_comments = self.find_all(project_id, ticket_id)
        if options[0].first.is_a? Array
          ticket_comments.select do |comment|
            comment if options[0].first.any? { |comment_id| comment_id == comment.id }
          end
        elsif options[0].first.is_a? Hash
          self.find_by_attributes(project_id, ticket_id, options[0].first)
        else
          ticket_comments
        end
      end

      def self.find_all(project_id, ticket_id)
        comment_id = 0
        ZendeskAPI::Ticket.find(ticket_id).comments.collect do |comment|
          comment_id += 1
          comment.author_id = USER_API.find(comment.author_id).email
          Comment.new [ticket_id, project_id, comment_id, comment]
        end
      end

      def self.find_by_attributes(project_id, ticket_id, attributes = {})
       search_by_attribute(self.find_all(project_id, ticket_id), attributes)
      end

    end

  end
end
