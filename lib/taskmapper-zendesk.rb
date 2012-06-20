require 'rubygems'
require 'zendesk_api'

%w{ zendesk ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end

