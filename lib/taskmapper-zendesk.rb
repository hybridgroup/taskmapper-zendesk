require File.dirname(__FILE__) + '/zendesk/zendesk-api'

%w{ zendesk ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end

