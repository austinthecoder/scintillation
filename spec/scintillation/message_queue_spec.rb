require 'spec_helper'

class MessageQueueTest
  include Scintillation::MessageQueue
end

describe MessageQueueTest do
  
  before do
    @mqt = MessageQueueTest.new
  end
  
  describe "#method_missing" do
    [[nil, nil], ['cool', nil], [nil, 'login'], ['cool', 'login']].each do |tone, namespace|
      method = "#{tone + '_' if tone}msg#{'_for_' + namespace if namespace}"
      describe "##{method}" do
        before do
          @msg = Scintillation::MessageQueue::Message.new(@text, @tone)
          Scintillation::MessageQueue::Message.stub!(:new => @msg)
        end
        
        it "should instantiate a message" do
          Scintillation::MessageQueue::Message.should_receive(:new).with('some message', tone)
          @mqt.send(method, 'some message')
        end
        
        it "should add the message to the #message_store" do
          @mqt.send(method, 'some message')
          @mqt.message_store[namespace].should == [@msg]
        end
      end
    end
    
    describe "#has_login_msgs?" do
      it "should return true when the #message_store has login messages" do
        @mqt.msg_for_login('hey')
        @mqt.has_login_msgs?.should be_true
      end
      
      it "should return false when the #message_store does not have login messages" do
        @mqt.msg('hey')
        @mqt.has_login_msgs?.should be_false
      end
      
      it "should return false when the #message_store does not have login messages" do
        @mqt.has_login_msgs?.should be_false
      end
    end
    
    describe "#has_msgs?" do
      it "should return true when the #message_store has messages" do
        @mqt.msg('hey')
        @mqt.has_msgs?.should be_true
      end
      
      it "should return false when the #message_store does not have messages" do
        @mqt.has_msgs?.should be_false
      end
    end
    
    describe "#login_msgs" do
      it "should return an empty array when the #message_store does not have login messages" do
        @mqt.msg('hello')
        @mqt.login_msgs.should == []
      end
      
      context "when the #message_store has login messages" do
        before do
          2.times { @mqt.msg_for_login('hello') }
        end
        
        it "should delete the messages from the #message_store" do
          @mqt.login_msgs
          @mqt.message_store['login'].should be_nil
        end
        
        it "should return the messages" do
          msgs = @mqt.message_store['login']
          @mqt.login_msgs.should == msgs
        end
      end
    end
  end
  
  describe "#message_store" do
    it "should return a hash" do
      @mqt.message_store.should == {}
    end
  end
  
end