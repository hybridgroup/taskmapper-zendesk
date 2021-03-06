require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Zendesk::Ticket do

  let(:project_id) { "hybridgroup-project" }
  let(:tm) { TaskMapper.new(:zendesk, :account => 'hybridgroup', :username => 'rafael@hybridgroup.com', :password => '123456') }
  let(:ticket_class) {  TaskMapper::Provider::Zendesk::Ticket }
  let(:project) { tm.project(project_id) } 
  let(:headers) { {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=','Accept' => 'application/json'} }
  let(:post_headers) { {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=','Content-Type' => 'application/json'} }

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
      subject { project.tickets [1] } 
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of ticket_class }
    end

    context "when calling #tickets with a hash attributes" do 
      subject { project.tickets :id => 1 }
      it { should be_an_instance_of Array } 
      it { subject.first.should be_an_instance_of ticket_class }
    end

    describe "Retrieving a single ticket" do 
      context "when calling #ticket to a project instance" do 
        subject { project.ticket 1 }
        it { should be_an_instance_of ticket_class }
        it { subject.title.should == "Testing" }
      end

      context "when calling #ticket with a hash attribute" do 
        subject { project.ticket :id => 1 }
        it { should be_an_instance_of ticket_class }
        it { subject.title.should == "Testing" }
      end
    end
  end

  describe "Create and update" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.post '/api/v1/tickets.json', post_headers, fixture_for('ticket'), 201 
      end
    end

    context "when #calling #ticket! to a project instance" do 
      subject { project.ticket! :title => 'Testing' }
      it { should be_an_instance_of ticket_class }
      it { subject.title.should == 'Testing' }
    end
  end
end
