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
      stub_get('https://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/api/v2/tickets', 'tickets')
      stub_get('https://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/api/v2/tickets/1', 'tickets/1')
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
        it { subject.title.should == "This is a sample ticket requested and submitted by you" }
      end

      context "when calling #ticket with a hash attribute" do 
        subject { project.ticket :id => 1 }
        it { should be_an_instance_of ticket_class }
        it { subject.title.should == "This is a sample ticket requested and submitted by you" }
      end

      context "when calling #ticket without created_at or updated_at" do 
        subject { project.ticket 1 }
        it { should be_an_instance_of ticket_class }
        it { subject.created_at.should_not be_nil }
        it { subject.updated_at.should_not be_nil }
      end
    end
  end

  describe "Create and update" do 
    before(:each) do 
      stub_get 'https://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/api/v2/users/me', 'users/228124428'
      stub_get 'https://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/api/v2/users/228124428', 'users/228124428'
    end

    context "when calling #ticket! to a project instance without description" do 
      subject {  project.ticket! :title => 'Testing'  }
      it { should raise_exception }
    end

  end
end
