require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zendesk::Ticket" do
  
   before(:all) do
     @project_id = "hybridgroup-project"
     headers = {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=', 'Accept' => 'application/json'}
     headers_post = {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=', 'Accept' => 'application/json'} 
     post_data = {:ticket => {:subject => "hello world", :requester_name => "Rafael George", :description => "here"}}.to_json
     ActiveResource::HttpMock.respond_to do |mock| 
       mock.get '/search.json?query=status%3Aopen',headers, fixture_for('tickets', 'json'), 200
       mock.get '/tickets/1.json', headers, fixture_for('ticket', 'json'), 200
       mock.post '/tickets.json', headers_post, post_data, 200
     end
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

   it "should be able to create a ticket" do
     ticket = @project.ticket!(:subject => 'hello world', :description => 'here', :requester_name => "Rafael George")
     ticket.should be_an_instance_of(@klass)
     ticket.id.should == 3
   end
end
