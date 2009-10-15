require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Scintillation::SessionMessages do
  it "should add/get messages" do
    sm = Scintillation::SessionMessages.new({})
    
    sm.add_message("a")
    sm.add_message("b", :tone => 'x')
    sm.add_message("c", :scope => 'y')
    sm.add_message("d", :tone => 'x', :scope => 'y')
    
    messages = sm.get_messages
    messages.size.should == 2
    messages.map { |m| [m.to_s, m.tone, m.scope] }.should == [['a', nil, nil], ['b', 'x', nil]]
    
    messages = sm.get_messages('z')
    messages.size.should == 0
    
    messages = sm.get_messages('y')
    messages.size.should == 2
    messages.map { |m| [m.to_s, m.tone, m.scope] }.should == [['c', nil, 'y'], ['d', 'x', 'y']]
  end
end

describe Scintillation::Message do
  it "should create" do
    m = Scintillation::Message.new("message")
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
  
    m = Scintillation::Message.new("message", nil, nil)
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
  
    m = Scintillation::Message.new("message", '', '')
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
  
    m = Scintillation::Message.new("message", ' ', ' ')
    [m.to_s, m.tone, m.scope].should == ['message', nil, nil]
  
    m = Scintillation::Message.new("message", 'positive', 'login')
    [m.to_s, m.tone, m.scope].should == ['message', 'positive', 'login']
  end
end