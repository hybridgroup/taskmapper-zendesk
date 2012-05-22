require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TaskMapper::Provider::Zendesk" do
  let(:tm) { TaskMapper.new(:zendesk, {:account => 'taskmapper', :username => 'foo', :password => '000000'}) }
  let(:headers) { {'Authorization' => 'Basic Zm9vOjAwMDAwMA==','Accept' => 'application/json'} }

  describe "Instance of TaskMapper" do 
    context "when initializing a new zendesk provider" do 
      subject { tm } 
      it { should be_an_instance_of TaskMapper }
      it { should be_a_kind_of TaskMapper::Provider::Zendesk }
    end
  end

  context "when calling #valid? to an instance of zendesk with invalid credentials" do 
    subject { tm.valid? }
    it { should be_false }
  end

  context "when calling #valid? to an instance of zendesk provider with correct credentials" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/search.json?query=status%3Aopen', headers, fixture_for('tickets'), 200
      end
    end

    subject { tm.valid? } 
    it { should be_true }
  end
end
