require 'rubygems'
require 'active_support'

module Scintillation
end

%w(controller view).each do |file|
  require Pathname.new(__FILE__).expand_path.parent.join('scintillation', file)
end

if defined?(Rails)
  ActionController::Base.send(:extend, Scintillation::Controller)
end