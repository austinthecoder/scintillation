module Scintillation
  module MessageQueue
    
    def message_store
      @message_store ||= {}
    end
  
    def method_missing(method, *args, &block)
      case method.to_s
      when /^((\w+)_)?msg(_for_(\w+))?$/
        (message_store[$4] ||= []) << Message.new(args[0], $2)
      when /^has_((\w+)_)?msgs\?$/
        !message_store[$2].empty?
      when /^((\w+)_)?msgs$/
        message_store.delete($2) || []
      else
        super
      end
    end
  
  end
end

require Pathname.new(__FILE__).expand_path.parent.join('message_queue', 'message')