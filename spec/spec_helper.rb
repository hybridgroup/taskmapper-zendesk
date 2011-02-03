$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'ticketmaster'
require 'ticketmaster-zendesk'
require 'spec'
require 'spec/autorun'
require 'fakeweb'

FakeWeb.allow_net_connect = false

Spec::Runner.configure do |config|
  
end

def fixture_for(name, format = 'xml')
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + ".#{format}")
end
