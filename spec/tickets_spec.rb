require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zendesk::Ticket" do

  before(:all) do
    @project_id = "hybridgroup-project"
    headers = {'Accept' => 'application/json'}
    FakeWeb.register_uri(:get, "http://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/search.json?query=status%3Aopen", :body => fixture_for('tickets','json'), :status => ["200", "OK"])
    FakeWeb.register_uri(:get, "http://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/tickets/1.json", :body => fixture_for('ticket','json'), :status => ["200", "OK"])
    FakeWeb.register_uri(:post, "http://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/tickets.json", :body => fixture_for('ticket','json'), :status => ["200", "OK"])
  end

  before(:each) do
    @ticketmaster = TicketMaster.new(:zendesk, :account => 'hybridgroup', :username => 'rafael@hybridgroup.com', :password => '123456')
    @klass = TicketMaster::Provider::Zendesk::Ticket
    @project = @ticketmaster.project(@project_id)
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on an array of id's" do 
    tickets = @project.tickets([1])
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(@klass)
    tickets.first.title.should == "Testing"
  end

  it "should be able to load all tickets based on attributes" do
    tickets = @project.tickets(:id => 1)
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(@klass)
    tickets.first.title.should == "Testing"
  end

  it "should be able to load a single ticket" do
    ticket = @project.ticket(1)
    ticket.should be_an_instance_of(@klass)
    ticket.title.should == "Testing"
  end

  it "should create a new ticket" do 
    ticket = @project.ticket!(:title => "Testing", :description => "testing")
    ticket.title.should == "Testing"
    ticket.should be_an_instance_of(@klass)
  end

  it "should be able to update a ticket" do 
    ticket = @project.ticket(1)
    ticket.title == "changed"
    ticket.save.should == true
  end

end
