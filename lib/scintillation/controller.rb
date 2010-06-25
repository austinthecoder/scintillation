require 'scintillation/message_queue'

module Scintillation
  module Controller
  
    def scintillate(options = {})
      include MessageQueue
      include InstanceMethods
      
      ActionView::Base.send(:include, Scintillation::View)
    
      options.reverse_merge!(:scope => :messages)
    
      helper_method :message_store
    
      define_method(:scintillation_scope) { options[:scope] }
    end
  
    module InstanceMethods
      def message_store
        @message_store ||= (session[scintillation_scope] ||= {})
      end
    end
  end
end