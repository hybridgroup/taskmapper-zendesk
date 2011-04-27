module TicketMaster::Provider
  module Zendesk
    # Project class for ticketmaster-zendesk
    # 
    # 
    class Project < TicketMaster::Provider::Base::Project
	 attr_accessor :prefix_options
      #API = ZendeskAPI::Organization
      # declare needed overloaded methods here
      
      def initialize(*object)
        if object.first
          object = object.first
          unless object.is_a? Hash
            @system_data = {:client => object}
            hash = {:repository => object.account,
                    :user => object.username,
                    :name => object.name}
          else
            hash = object
          end
          super hash
        end
      end
      
      # copy from this.copy(that) copies that into this
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(:title => ticket.title, :description => ticket.description)
          ticket.comments.each do |comment|
            copy_ticket.comment!(:body => comment.body)
            sleep 1
          end
        end
      end

      def tickets(*options)
        Ticket.find(self.name, options)
      end

      def ticket(*options)
        if options.first.is_a? Fixnum
          ticket_id = options.first
          Ticket.find_by_id(self.name, ticket_id)
        elsif options.first.is_a? Hash
          Ticket.find_by_attributes(self.name, options.first).first
        else
          TicketMaster::Provider::Zendesk::Ticket
        end
      end

      def ticket!(*options)
        Ticket.new ZendeskAPI::Ticket.create(options.first), self.name
      end

    end
  end
end
