class ZendeskAPI::Ticket 
  ZENDESK_USER = ZendeskAPI::User

  def update_with(ticket)
    self.description = ticket.description
    self.nice_id = ticket.id
    self.id = ticket.id
    self
  end

  def to_ticket_hash
    {:id => nice_id,
     :title => subject, 
     :project_id => attributes[:project_id],
     :requestor => requestor(requester_id),
     :assignee => assignee(assignee_id) 
     }
  end

  private
  def requestor(id)
    ZENDESK_USER.find(id).email
  end

  def assignee(id)
    ZENDESK_USER.find(id).email
  end
end
