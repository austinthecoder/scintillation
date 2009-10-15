require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module ActiveRecord; Errors = Struct.new(nil); end

describe Scintillation::SessionMessages do
  it "should add/get messages" do
    sm = Scintillation::SessionMessages.new({})
    
    sm.add("a")
    sm.add("b", 'x')
    sm.add("c", nil, 'y')
    sm.add("d", 'x', 'y')
    
    messages = sm.get
    messages.size.should == 2
    messages.map { |m| [m.to_s, m.tone] }.should == [['a', nil], ['b', 'x']]
    
    messages = sm.get('z')
    messages.size.should == 0
    
    messages = sm.get('y')
    messages.size.should == 2
    messages.map { |m| [m.to_s, m.tone] }.should == [['c', nil], ['d', 'x']]
  end
end

describe Scintillation::Message do
  it "should create" do
    m = Scintillation::Message.new("message")
    [m.to_s, m.tone].should == ['message', nil]
  
    m = Scintillation::Message.new("message", nil)
    [m.to_s, m.tone].should == ['message', nil]
  
    m = Scintillation::Message.new("message", '')
    [m.to_s, m.tone].should == ['message', nil]
  
    m = Scintillation::Message.new("message", ' ')
    [m.to_s, m.tone].should == ['message', nil]
  
    m = Scintillation::Message.new("message", 'positive')
    [m.to_s, m.tone].should == ['message', 'positive']
  end
end