module Scintillation
  
  module ControllerHelpers
    def self.included(base)
      base.helper_method(:messages)
      base.before_filter { |c| c.send(:flash).each { |t, m| c.messages.add(m, t) } }
    end
    
    def messages
      @messages ||= Scintillation::SessionMessages.new(session)
    end
    
    def method_missing(method, *args, &block)
      if /^((\w+)_)?msg(_for_(\w+))?$/.match(method.to_s)
        messages.add(args[0], $2, $4)
      elsif /^((\w+)_)?msgs$/.match(method.to_s)
        messages.get($2)
      else
        raise method.inspect
        super(method.to_sym, args, &block)
      end
    end
  end
  
  ##################################################
  
  module ViewHelpers
    def method_missing(method, *args, &block)
      if /^((\w+)_)?msgs$/.match(method.to_s)
        messages.get($2)
      else
        super(method.to_sym, args, &block)
      end
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
        when ActiveRecord::Errors then obj.full_messages
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