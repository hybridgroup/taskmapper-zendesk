class ZendeskAPI::Ticket 
  def update_with(ticket)
    self.description = ticket.title
    self
  end
end
