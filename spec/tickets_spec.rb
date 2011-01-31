require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zendesk::Ticket" do
  
   before(:all) do
     @project_id = "hybridgroup-project"
     headers = {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=', 'Accept' => 'application/xml'}
     ActiveResource::HttpMock.respond_to do |mock| 
       mock.get '/search.xml?query%3Dstatus%3Aopen=',headers, fixture_for('tickets'), 200
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

end
