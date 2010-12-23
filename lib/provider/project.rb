module TicketMaster::Provider
  module Zen
    # Project class for ticketmaster-zendesk
    # 
    # 
    class Project < TicketMaster::Provider::Base::Project
	 attr_accessor :prefix_options
#	 API = ZendeskAPI::Project 
      # declare needed overloaded methods here
      
      
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

    end
  end
end
