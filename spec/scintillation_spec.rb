require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

SampleData = Struct.new(:setter_method, :getter_method, :tone, :scope) do
  def body
    setter_method
  end
end

describe "Scintillation" do
  it "messages" do
    msgs_obj = Soccer022483::Scintillation::Messages.new
    msgs_obj.instance_variable_get(:@messages).should be_empty
    
    samples = []
    samples << SampleData.new('message', 'messages', nil, nil)
    samples << SampleData.new('positive_message', 'positive_messages', 'positive', nil)
    samples << SampleData.new('message_for_login', 'messages_for_login', nil, 'login')
    samples << SampleData.new('negative_message_for_user', 'negative_messages_for_user', 'negative', 'user')
    
    samples.each { |s| msgs_obj.send(s.setter_method, s.body) }
    
    size = 4
    
    samples.each do |s|
      msgs_obj.instance_variable_get(:@messages).size.should == size
      msgs = msgs_obj.send(s.getter_method)
      msgs.size.should == 1
      msgs.map { |m| [m.to_s, m.tone, m.scope] }.should == [[s.body, s.tone, s.scope]]
      size -= 1
    end
  end
  
  it "message" do
    m = Soccer022483::Scintillation::Message.new("message")
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
    
    m = Soccer022483::Scintillation::Message.new("message", nil, nil)
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
    
    m = Soccer022483::Scintillation::Message.new("message", '', '')
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
    
    m = Soccer022483::Scintillation::Message.new("message", ' ', ' ')
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
    
    m = Soccer022483::Scintillation::Message.new("message", 'positive', 'login')
    [m.to_s, m.tone, m.scope].should == ['message', 'positive', 'login']
  end
end