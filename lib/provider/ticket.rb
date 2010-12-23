
module TicketMaster::Provider
  module Zen
    # Ticket class for ticketmaster-zendesk
    #
    require 'ticketmaster'    
    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here
      
      def id
        @system_data[:client].number
      end
	  
	  # This is to get the status, mapped to state
      def status
        state
      end
	  
	  def self.find_by_id(project_id, id)
        self.search(project_id, {'id' => id}).first
      end
      
      def self.find_by_attributes(project_id, attributes = {})
        self.search(project_id, attributes)
      end
    end
  end
end
