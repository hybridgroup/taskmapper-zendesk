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
        if options.empty?
          Ticket.find_all(self.name).collect { |ticket| Ticket.new [ticket, self.name]}
        elsif options.first.is_a? Array
          Ticket.find_all(self.name).collect { |ticket| ticket if options.first.any? { |ticket_id| ticket_id == ticket.id }}
        elsif options.first.is_a? Hash
          Ticket.find_all(self.name).select do |ticket|
            options.first.inject(true) do |memo, kv|
              break unless memo
              key, value = kv
              begin
                memo &= ticket.send(key)
              rescue NoMethodError
                memo = false
              end
              memo
            end
          end
        end
      end

      def ticket(*options)
        ticket_id = options.first
        Ticket.find_by_id(ticket_id)
      end

      def ticket!(*options)
        Ticket.new [ZendeskAPI::Request.create(options.first), self.name]
      end

    end
  end
end
