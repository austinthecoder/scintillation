module Scintillation
  module MessageQueue
    class Message
      def initialize(text, tone)
        @text = text.to_s
        @tone = tone
      end
      
      attr_reader :text, :tone
      
      alias_method :to_s, :text
      
      def ==(message)
        text == message.text && tone == message.tone
      end
    end
  end
end