$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'taskmapper'
require 'taskmapper-zendesk'
require 'rspec'
require 'fakeweb'

FakeWeb.allow_net_connect = false


RSpec.configure do |config|
  config.color_enabled = true
end

def fixture_file(name, format = 'json')
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + ".#{format}")
end

def stub_request(method, url, filename, status = nil)
  options = {:body => ""}
  options.merge!({:body => fixture_file(filename)}) if filename
  options.merge!({:body => status.last}) if status
  options.merge!({:status => status}) if status

  FakeWeb.register_uri(method, url, options)
end

def stub_get(*args); stub_request(:get, *args) end
def stub_post(*args); stub_request(:post, *args) end
