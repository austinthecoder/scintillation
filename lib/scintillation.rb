module Scintillation
  
  module ControllerHelpers
    def self.included(base)
      base.helper_method(:messages)
    end
    
    def messages
      @messages ||= Scintillation::SessionMessages.new(session)
    end
    
    def method_missing(name, *args)
      /^(([a-z]+)_)?msg(_for_([a -z]+))?$/.match(name.to_s) ? messages.add(args[0], $2, $4) : super
    end
  end
  
  ##################################################
  
  module ViewHelpers
    def method_missing(name, *args)
      /^(([a-z]+)_)?msgs$/.match(name.to_s) ? messages.get($2) : super
    end
  end
  
  ##################################################
  
  class SessionMessages
    def initialize(session)
      @session = session
      @session[:messages] = {}
    end
    
    def add(body, tone = nil, scope = nil)
      (@session[:messages][scope.to_s] ||= []) << Scintillation::Message.new(body, tone)
    end
    
    def get(scope = nil)
      @session[:messages].delete(scope.to_s) || []
    end
  end
  
  ##################################################
  
  class Message
    attr_reader :to_s, :tone
  
    def initialize(body, tone = nil)
      @to_s = body.to_s
      @tone = tone.to_s unless tone !~ /\S/
    end
  end
  
end

if defined? Rails
  ActionController::Base.send(:include, Scintillation::ControllerHelpers)
  ActionView::Base.send(:include, Scintillation::ViewHelpers)
end