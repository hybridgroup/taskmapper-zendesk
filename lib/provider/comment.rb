module TaskMapper::Provider
  module Zendesk
    # The comment class for taskmapper-zendesk
    #
    # Do any mapping between taskmapper and your system's comment model here
    # versions of the ticket.
    #
    class Comment < TaskMapper::Provider::Base::Comment
      # declare needed overloaded methods here

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

      def author
        USER_API.find(comment.author_id).email
      end

      def id
        self.comment_id
      end

      def created_at
        Time.parse(self[:created_at])
      end

      def updated_at
        Time.parse(self[:updated_at])
      end

      class << self
        def search(project_id, ticket_id, options = {}, limit = 1000)
          comment_id = 0
          TaskMapper::Provider::Zendesk.api.tickets.find(:id => ticket_id)
        end

        def find_by_id(project_id, ticket_id, id) 
          search(project_id, ticket_id).find { |ticket| ticket.id == id } 
        end

        def find_by_attributes(project_id, ticket_id, attributes = {})
          search_by_attribute(search(project_id, ticket_id), attributes)
        end
      end
    end
  end
end
