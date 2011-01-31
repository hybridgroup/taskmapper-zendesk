
module TicketMaster::Provider
  module Zendesk

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here

      API = ZendeskAPI::Search

      def initialize(*object)
        if object.first 
          args = object.first
          object = args.shift
          project_id = args.shift
          @system_data = {:client => object}
          unless object.is_a? Hash
            hash = {:id => object.id,
                    :status => object.status,
                    :title => object.subject,
                    :created_at => object.created-at,
                    :updated_at => object.updated-at,
                    :description => object.description,
                    :assignee => object.assignee,
                    :requestor => object.requestor,
                    :project_id => project_id}
          else
            hash = object
          end
          super hash
        end
      end

    end

  end
end
