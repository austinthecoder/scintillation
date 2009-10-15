module Scintillation
  
  module Messageable
    def method_missing(name, *args)
      if /^(([a-z]+)_)?msg(_for_([a -z]+))?$/.match(name.to_s)
        messages.add(args.first, :tone => $2, :scope => $4)
      elsif /^(([a-z]+)_)?msgs$/.match(name.to_s)
        messages.get($2)
      else
        super
      end
    end
  end
  
  ##################################################
  
  module ControllerHelpers
    include Scintillation::Messageable
    
    def self.included(base)
      base.helper_method(:messages)
    end
    
    def messages
      @messages ||= Scintillation::SessionMessages.new(session)
    end
  end
  
  ##################################################
  
  module ViewHelpers
    include Scintillation::Messageable
  end
  
  ##################################################
  
  class SessionMessages
    def initialize(session)
      @session = session
      @session[:messages] = []
    end
    
    def add(body, options = {})
      @session[:messages] << Scintillation::Message.new(body, options[:tone], options[:scope])
    end
    
    def get(scope = nil)
      msgs = []
      @session[:messages].delete_if { |m| msgs << m if m.scope == scope }
      msgs
    end
  end
  
  ##################################################
  
  class Message
    attr_reader :to_s, :tone, :scope

    def initialize(body, tone = nil, scope = nil)
      @to_s = body.to_s
      @tone = tone.to_s unless tone !~ /\S/
      @scope = scope.to_s unless scope !~ /\S/
    end
  end
  
end

if defined? Rails
  ActionController::Base.send(:include, Scintillation::ControllerHelpers)
  ActionView::Base.send(:include, Scintillation::ViewHelpers)
end