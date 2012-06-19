require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Zendesk::Comment do
  let(:project_id) { 'hybridgroup-project' }
  let(:headers) { {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=','Accept' => 'application/json'} }
  let(:tm) { TaskMapper.new(:zendesk, :account => 'hybridgroup', :username => 'rafael@hybridgroup.com', :password => '123456') }
  let(:project) { tm.project(project_id) }
  let(:comment_class) { TaskMapper::Provider::Zendesk::Comment }

  describe "Retrieving comments" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/tickets/2.json', headers, fixture_for('ticket'), 200
        mock.get '/api/v1/tickets/1.json', headers, fixture_for('ticket'), 200
      end
    end
    let(:ticket) { project.ticket 2 }

    context "when calling #comments to a ticket instance" do 
      subject { ticket.comments } 
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
    end

    context "when calling #comments with an array of id" do 
      subject { ticket.comments [1] }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
    end

    context "when calling #comments with a hash of attributes" do 
      subject { ticket.comments :ticket_id => ticket.id }
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
    end

    describe "Retrieve a single comment" do 
      context "when calling #comment with an id to a ticket instance" do 
        subject { ticket.comment 1 }
        it { should be_an_instance_of comment_class }
        it { subject.id.should == 1 }
        it { subject.body.should_not be_nil }
        it { subject.author.should_not be_nil }
        it { subject.created_at.should_not be_nil }
        it { subject.updated_at.should_not be_nil }
      end

      context "when calling #comment with a hash attributes to a ticket instance" do 
        subject { ticket.comment :ticket_id => 1 }
        it { should be_an_instance_of comment_class }
        it { subject.id.should == 1 }
      end
    end
  end
end
