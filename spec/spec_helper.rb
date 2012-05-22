$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'taskmapper'
require 'taskmapper-zendesk'
require 'rspec'


RSpec.configure do |config|
  config.color_enabled = true
  
end

def fixture_for(name, format = 'json')
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + ".#{format}")
end
