require 'spec_helper'

class MessageQueueTest
  include Scintillation::MessageQueue
end

describe Scintillation::MessageQueue do
  before do
    @mqt = MessageQueueTest.new
  end
  
  def create_message(text, tone)
    Scintillation::MessageQueue::Message.new(text, tone)
  end
  
  describe "adding messages" do
    it "should be able to add messages with no tone or scope" do
      args = ["msg", nil]
      msg = create_message(*args)
      Scintillation::MessageQueue::Message.stub!(:new).with(*args).and_return(msg)
      @mqt.msg(args[0])
      @mqt.message_store.should == {nil => [msg]}
    end
  
    it "should be able to add messages with a tone" do
      args = ["msg", "cool"]
      msg = create_message(*args)
      Scintillation::MessageQueue::Message.stub!(:new).with(*args).and_return(msg)
      @mqt.cool_msg(args[0])
      @mqt.message_store.should == {nil => [msg]}
    end
  
    it "should be able to add messages with a scope" do
      args = ["msg", nil]
      msg = create_message(*args)
      Scintillation::MessageQueue::Message.stub!(:new).with(*args).and_return(msg)
      @mqt.msg_for_login(args[0])
      @mqt.message_store.should == {'login' => [msg]}
    end
  
    it "should be able to add messages with a tone and scope" do
      args = ["msg", "cool"]
      msg = create_message(*args)
      Scintillation::MessageQueue::Message.stub!(:new).with(*args).and_return(msg)
      @mqt.cool_msg_for_login(args[0])
      @mqt.message_store.should == {'login' => [msg]}
    end
  end
  
  describe "with some messages added" do
    before do
      @mqt.msg("msg")
      @mqt.cool_msg("cool msg")
      @mqt.msg_for_login("msg for login")
      @mqt.cool_msg_for_login("cool msg for login")
    end
    
    it "should retrieve messages by scope" do
      @mqt.msgs.should == [
        create_message("msg", nil),
        create_message("cool msg", "cool"),
      ]
      @mqt.login_msgs.should == [
        create_message("msg for login", nil),
        create_message("cool msg for login", "cool"),
      ]
      @mqt.message_store.should be_empty
    end
  end
end