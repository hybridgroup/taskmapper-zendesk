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
        mock.get '/api/v1/tickets/2.json', headers, fixture_for('tickets/2'), 200
      end
      @ticket = project.ticket(2)
    end

    context "when calling #comments to a ticket instance" do 
      subject { @ticket.comments } 
      it { should be_an_instance_of Array }
      it { subject.first.should be_an_instance_of comment_class }
    end
  end

  it "should be able to load all comments" do 
    pending
    comments = @ticket.comments
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all comments based on an array of id's" do 
    pending
    comments = @ticket.comments([1])
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
    comments.first.id.should == 1
  end

  it "should be able to load all comments based on attributes" do
    pending
    comments = @ticket.comments(:ticket_id => @ticket.id)
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
    comments.first.id.should == 1
  end

  it "should be able to load a comment based on id" do
    pending
    comment = @ticket.comment(1)
    comment.should be_an_instance_of(@klass)
    comment.id.should == 1
  end

  it "should be able to load a ticket based on attributes" do 
    pending
    comment = @ticket.comment(:ticket_id => 1)
    comment.should be_an_instance_of(@klass)
    comment.id.should == 1
  end

end
