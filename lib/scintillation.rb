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
        super
      end
    end
  end
  
  ##################################################
  
  module ViewHelpers
    def method_missing(method, *args, &block)
      if /^((\w+)_)?msgs$/.match(method.to_s)
        messages.get($2)
      else
        super
      end
    end
    
    def display_messages(msgs)
      unless msgs.empty?
        "<ul>\n  " + msgs.map { |m| "<li class=\"#{m.tone}\">#{m}</li>" }.join("\n  ") + "\n</ul>"
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
      
      case obj
        when Array then obj.each { |o| add(o, tone, scope) }
        when ActiveRecord::Errors then add(obj.full_messages, tone, scope)
        when String, Symbol then @session[:messages][scope.to_s] << Scintillation::Message.new(obj, tone)
        else
          if obj.respond_to?(:each)
            obj.each { |o| add(o, tone, scope) }
          else
            raise ArgumentError
          end
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
  #a fix until they patch
  module ActionController
    class Base
      def method_missing(method, *args, &block)
        super(method.to_sym, args, &block)
      rescue NoMethodError
        default_render
      end
    end
  end
  
  ActionController::Base.send(:include, Scintillation::ControllerHelpers)
  ActionView::Base.send(:include, Scintillation::ViewHelpers)
end