module Scintillation
  
  module ControllerHelpers
    def self.included(base)
      base.helper_method(:messages)
      base.before_filter { |c| c.send(:flash).each { |t, m| c.messages.add(m, t) } }
    end
    
    def messages
      @messages ||= Scintillation::SessionMessages.new(session)
    end
    
    def method_missing(name, *args)
      /^((\w+)_)?msg(_for_(\w+))?$/.match(name.to_s) ? messages.add(args[0], $2, $4) : super
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
      @session[:messages] ||= {}
      @temp_msgs = {}
    end
    
    def add(obj, tone = nil, scope = nil)
      @session[:messages][scope.to_s] ||= []
      @session[:messages][scope.to_s] += case obj
        when ActiveRecord::Errors then obj.error.full_messages
        else [Scintillation::Message.new(obj, tone)]
      end
    end
    
    def get(scope = nil)
      @temp_msgs[scope.to_s] ||= (@session[:messages].delete(scope.to_s) || [])
    end
  end
  
  ##################################################
  
  Message = Struct.new(:to_s, :tone)
  
end

if defined? Rails
  ActionController::Base.send(:include, Scintillation::ControllerHelpers)
  ActionView::Base.send(:include, Scintillation::ViewHelpers)
end