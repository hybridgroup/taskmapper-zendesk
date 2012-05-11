require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Zendesk::Project do
  before(:all) do
    @project_id = 'foobar-project'
  end

  before(:each) do 
    @taskmapper = TaskMapper.new(:zendesk, {:account => 'hybridgroup', :username => 'foobar', :password => '123456'})
    @klass = TaskMapper::Provider::Zendesk::Project
  end

  it "should be able to load all projects" do 
    @taskmapper.projects.should be_an_instance_of(Array)
    @taskmapper.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all projects from an array of id's" do 
    @projects = @taskmapper.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load a single project by id" do
    @project = @taskmapper.project(@project_id)
    @project.should be_an_instance_of(@klass)
  end

end
