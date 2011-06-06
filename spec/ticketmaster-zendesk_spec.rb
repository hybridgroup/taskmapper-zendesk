require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zendesk" do
  before(:each) do 
    @ticketmaster = TicketMaster.new(:zendesk, {:account => 'ticketmaster', :username => 'foo', :password => '000000'})
    headers = {'Authorization' => 'Basic Zm9vOjAwMDAwMA==','Accept' => 'application/json'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/search.json?query=status%3Aopen', headers, fixture_for('tickets', 'json'), 200
    end

  end

  it "should be able to instantiate a new instance" do
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Zendesk)
  end

  it "should be true with valid authentication" do 
    @ticketmaster.valid?.should be_true
  end

end
