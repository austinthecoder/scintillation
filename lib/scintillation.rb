module Scintillation
  
  def self.included(base)
    base.send(:include, Controller)
  end
  
  module Controller
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def scintillate(options = {})
        include InstanceMethods
        ActionView::Base.send(:include, Scintillation::View)
        
        # import flash messages
        before_filter { |c| c.send(:flash).each { |t, m| c.messages.add(m, t) } }
        
        helper_method :messages
        
        define_method(:messages) do
          @messages ||= Scintillation::SessionMessages.new(session, :scope => options[:scope])
        end
      end
    end
    
    module InstanceMethods
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
  end
  
  ##################################################
  
  module View
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
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
  end
  
  ##################################################
  
  class SessionMessages
    def initialize(session, options = {})
      options.reverse_merge!(:scope => :messages)
      @session = session
      @session_scope = options[:scope]
      @temp_msgs = {}
    end
    
    def msgs
      @session[@session_scope] ||= {}
    end
    
    def add(obj, tone = nil, scope = nil)
      msgs[scope.to_s] ||= []
      
      case obj
        when String, Symbol then msgs[scope.to_s] << Scintillation::Message.new(obj, tone)
        when ActiveRecord::Errors then add(obj.full_messages, tone, scope)
        when Enumerable then obj.each { |o| add(o, tone, scope) }
        else add(obj.to_s, tone, scope)
      end
    end
    
    def get(scope = nil)
      @temp_msgs[scope.to_s] ||= (msgs.delete(scope.to_s) || [])
    end
  end
  
  ##################################################
  
  Message = Struct.new(:to_s, :tone)
  
end

if defined?(Rails)
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
  
  ActionController::Base.send(:include, Scintillation)
end