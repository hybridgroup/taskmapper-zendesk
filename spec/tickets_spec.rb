require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Zendesk::Ticket do

  let(:project_id) { "hybridgroup-project" }
  let(:tm) { TaskMapper.new(:zendesk, :account => 'hybridgroup', :username => 'rafael@hybridgroup.com', :password => '123456') }
  let(:ticket_class) {  TaskMapper::Provider::Zendesk::Ticket }
  let(:project) { tm.project(project_id) } 
  let(:headers) { {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=','Accept' => 'application/json'} }

  describe "Retrieving tickets" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/search.json?query=status%3Aopen', headers, fixture_for('tickets'), 200
        mock.get '/api/v1/tickets/1.json', headers, fixture_for('tickets/1'), 200
        mock.get '/api/v1/users/26218414.json', headers, fixture_for('users/55030073'), 200
        mock.get '/api/v1/users/26220353.json', headers, fixture_for('users/55030073'), 200
      end
    end
    
    context "when calling #tickets" do 
      subject { project.tickets } 
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of ticket_class }
    end

    context "when calling #tickets with array of id's" do 
      subject { project.tickets([1]) } 
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of ticket_class }
    end
  end

  it "should be able to load all tickets based on an array of id's" do 
    pending
    tickets = @project.tickets([1])
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(@klass)
    tickets.size.should == 1
    tickets.first.title.should == "Testing"
  end

  it "should be able to load all tickets based on attributes" do
    pending
    tickets = @project.tickets(:id => 1)
    tickets.should be_an_instance_of(Array)
    tickets.first.should be_an_instance_of(@klass)
    tickets.first.title.should == "Testing"
  end

  it "should be able to load a single ticket" do
    pending
    ticket = @project.ticket(1)
    ticket.should be_an_instance_of(@klass)
    ticket.title.should == "Testing"
  end

  it "should be able to find a ticket by attributes" do 
    pending
    ticket = @project.ticket(:id => 1)
    ticket.should be_an_instance_of(@klass)
    ticket.title.should == "Testing"
  end

  it "should return the ticket class without parameter in the ticket method" do
    pending
    @project.ticket.should == @klass
  end

end
