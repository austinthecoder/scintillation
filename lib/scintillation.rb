module Soccer022483
  module Scintillation
    class Messages
      def initialize
        @messages = []
      end
      
      def method_missing(name, *args)
        if /^(([a-z]+)_)?(message(s)?)(_for_([a -z]+))?$/.match(name.to_s)
          options = {:tone => $2, :scope => $6}
          ($3 == 'message') ? send(:add, args.first, options) : send(:get, options)
        else
          super
        end
      end
      
      private
      
      def add(body, options = {})
        @messages << Message.new(body, options[:tone], options[:scope])
      end
      
      def get(options = {})
        msgs = []
        @messages.delete_if do |m|
          msgs << m if {:tone => m.tone, :scope => m.scope} == options
        end
        msgs
      end
    end
    
    class Message
      attr_reader :to_s, :tone, :scope
      
      def initialize(body, tone = nil, scope = nil)
        @to_s = body.to_s
        @tone = tone.to_s unless tone !~ /\S/
        @scope = scope.to_s unless scope !~ /\S/
      end
    end
  end
end