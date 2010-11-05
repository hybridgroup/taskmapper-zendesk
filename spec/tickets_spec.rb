require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zendesk::Ticket" do
  
   before(:all) do
    headers = {'Authorization' => 'Basic Zm9vOjAwMDAwMA==', 'Accept' => 'application/xml'}
    headers_post_put = {'Authorization' => 'Basic Zm9vOjAwMDAwMA==', 'Content-Type' => 'application/xml'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/tickets/2.xml', headers, fixture_for('tickets/2'), 200
      mock.get '/tickets.xml', headers, fixture_for('tickets'), 200
      mock.put '/tickets/2.xml', headers_post_put, '', 200
      mock.post '/tickets.xml', headers_post_put, fixture_for('tickets/create'), 200
    end
  end
  
  before(:each) do
    @ticketmaster = TicketMaster.new(:zendesk, :account => 'ticketmaster', :username => 'foo', :password => '000000')
    @klass = TicketMaster::Provider::Zendesk::Ticket
  end
  
  #it "should be able to load all tickets" do
  #  @ticketmaster.tickets.should be_an_instance_of(Array)
  #  @ticketmaster.tickets.first.should be_an_instance_of(@klass)
  #end
  
  
  it "should be able to load a single ticket" do
    @ticket = @ticketmaster.ticket.find(3)
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == 3
  end
  
end
