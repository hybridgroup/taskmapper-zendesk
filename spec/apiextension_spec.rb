require File.expand_path(File.dirname(__FILE__)) + '/spec_helper'

describe "Extending ZendeskAPI::Ticket" do 
  context "calling #update_with" do 
    subject { ZendeskAPI::Ticket.new.respond_to? :update_with }
    it { should be_true }
  end

  context "calling #update_with passing a Taskmapper ticket" do 
    let(:ticket) { TaskMapper::Provider::Zendesk::Ticket.new({:attributes => 'yes'}) }
    subject { ZendeskAPI::Ticket.new.update_with(ticket) }
    it { should be_an_instance_of ZendeskAPI::Ticket }
  end

  context "calling #to_ticket_hash" do 
    subject { ZendeskAPI::Ticket.new.respond_to? :to_ticket_hash } 
    it { should be_true }
  end
end
