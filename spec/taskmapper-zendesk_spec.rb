require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskMapper::Provider::Zendesk" do
  before(:each) do 
    @taskmapper = TaskMapper.new(:zendesk, {:account => 'taskmapper', :username => 'foo', :password => '000000'})
    headers = {'Authorization' => 'Basic Zm9vOjAwMDAwMA==','Accept' => 'application/json'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/api/v1/search.json?query=status%3Aopen', headers, fixture_for('tickets', 'json'), 200
    end

  end

  it "should be able to instantiate a new instance" do
    @taskmapper.should be_an_instance_of(TaskMapper)
    @taskmapper.should be_a_kind_of(TaskMapper::Provider::Zendesk)
  end

  it "should be true with valid authentication" do 
    @taskmapper.valid?.should be_true
  end

end
