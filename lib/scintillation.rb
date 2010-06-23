require 'active_support'
require 'scintillation/controller'
require 'scintillation/view'

module Scintillation
end

if defined?(Rails)
  ActionController::Base.send(:extend, Scintillation::Controller)
end