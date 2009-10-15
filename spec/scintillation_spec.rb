require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Scintillation::SessionMessages do
  it "should add/get messages" do
    sm = Scintillation::SessionMessages.new({})
    
    sm.add("a")
    sm.add("b", :tone => 'x')
    sm.add("c", :scope => 'y')
    sm.add("d", :tone => 'x', :scope => 'y')
    
    messages = sm.get
    messages.size.should == 2
    messages.map { |m| [m.to_s, m.tone, m.scope] }.should == [['a', nil, nil], ['b', 'x', nil]]
    
    messages = sm.get('z')
    messages.size.should == 0
    
    messages = sm.get('y')
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