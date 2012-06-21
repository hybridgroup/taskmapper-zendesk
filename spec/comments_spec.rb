require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Zendesk::Comment do
  let(:project_id) { 'hybridgroup-project' }
  let(:headers) { {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=','Accept' => 'application/json'} }
  let(:tm) { TaskMapper.new(:zendesk, :account => 'hybridgroup', :username => 'rafael@hybridgroup.com', :password => '123456') }
  let(:project) { tm.project(project_id) }
  let(:comment_class) { TaskMapper::Provider::Zendesk::Comment }

  describe "Retrieving comments" do 
    before(:each) do 
      stub_get 'https://rafael%40hybridgroup.com:123456@hybridgroup.zendesk.com/api/v2/tickets/3', 'tickets/3'
    end
    let(:ticket) { project.ticket 3 }

    context "when calling #comments to a ticket instance" do 
      pending { should be_an_instance_of Array }
      pending { subject.first.should be_an_instance_of comment_class }
    end

    context "when calling #comments with an array of id" do 
      pending { should be_an_instance_of Array }
      pending { subject.first.should be_an_instance_of comment_class }
    end

    context "when calling #comments with a hash of attributes" do 
      pending { should be_an_instance_of Array }
      pending { subject.first.should be_an_instance_of comment_class }
    end

    describe "Retrieve a single comment" do 
      context "when calling #comment with an id to a ticket instance" do 
        pending { should be_an_instance_of comment_class }
        pending { subject.id.should == 1 }
      end

      context "when calling #comment with a hash attributes to a ticket instance" do 
        pending { should be_an_instance_of comment_class }
        pending { subject.id.should == 1 }
      end
    end
  end
end
