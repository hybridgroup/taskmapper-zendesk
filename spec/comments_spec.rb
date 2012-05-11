require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Zendesk::Comment do

  before(:all) do 
    @project_id = 'hybridgroup-project'
    @ticket_id = 1
    headers = {'Authorization' => 'Basic cmFmYWVsQGh5YnJpZGdyb3VwLmNvbToxMjM0NTY=','Accept' => 'application/json'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/tickets/1.json', headers, fixture_for('ticket','json'), 200
      mock.get '/users/26218414.json', headers, fixture_for('users/55030073', 'json'), 200
      mock.get '/users/26220353.json', headers, fixture_for('users/55030073', 'json'), 200
    end
  end

  before(:each) do 
    @taskmapper = TaskMapper.new(:zendesk, :account => 'hybridgroup', :username => 'rafael@hybridgroup.com', :password => '123456')
    project = @taskmapper.project(@project_id)
    @ticket = project.ticket(@ticket_id)
    @klass = TaskMapper::Provider::Zendesk::Comment
  end

  it "should be able to load all comments" do 
    comments = @ticket.comments
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all comments based on an array of id's" do 
    comments = @ticket.comments([1])
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
    comments.first.id.should == 1
  end

  it "should be able to load all comments based on attributes" do
    comments = @ticket.comments(:ticket_id => @ticket.id)
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(@klass)
    comments.first.id.should == 1
  end

  it "should be able to load a comment based on id" do
    comment = @ticket.comment(1)
    comment.should be_an_instance_of(@klass)
    comment.id.should == 1
  end

  it "should be able to load a ticket based on attributes" do 
    comment = @ticket.comment(:ticket_id => 1)
    comment.should be_an_instance_of(@klass)
    comment.id.should == 1
  end

end
