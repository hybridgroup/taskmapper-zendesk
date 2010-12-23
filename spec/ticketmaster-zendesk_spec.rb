require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zen" do
  
  it "should be able to instantiate a new instance" do
    @ticketmaster = TicketMaster.new(:zendesk, {:account => 'ticketmaster', :username => 'foo', :password => '000000'})
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Zen)
  end
  
end
