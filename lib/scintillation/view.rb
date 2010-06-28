module Scintillation
  module View
    
    def method_missing(method, *args, &block)
      case method.to_s
      when /^has_((\w+)_)?msgs\?$/
        message_store[$2] && !message_store[$2].empty?
      when /^((\w+)_)?msgs$/
        message_store.delete($2) || []
      else
        super
      end
    end
    
  end
end