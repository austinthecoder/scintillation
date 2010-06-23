module Scintillation
  module MessageQueue
    class Message
      def initialize(text, tone)
        self.text, self.tone = text, tone
      end

      attr_accessor :tone
      attr_reader :text

      alias_method :to_s, :text

      def text=(val)
        @text = val.to_s
      end
      
      def ==(message)
        text == message.text && tone == message.tone
      end
    end
  end
end