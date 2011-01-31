require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Zendesk::Project" do
  before(:all) do
    @project_id = 'foobar-project'
  end

  before(:each) do 
    @ticketmaster = TicketMaster.new(:zendesk, {:account => 'hybridgroup', :username => 'foobar', :password => '123456'})
    @klass = TicketMaster::Provider::Zendesk::Project
  end

  it "should be able to load all projects" do 
    @ticketmaster.projects.should be_an_instance_of(Array)
    @ticketmaster.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all projects from an array of id's" do 
    @projects = @ticketmaster.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load a single project by id" do
    @project = @ticketmaster.project(@project_id)
    @project.should be_an_instance_of(@klass)
  end

end
