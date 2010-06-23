require 'spec_helper'
require 'action_controller'

class ControllerTest < ActionController::Base
  extend Scintillation::Controller
  
  def session
    @session ||= {}
  end
end

describe Scintillation::Controller do
  describe "scintillate" do
    before do
      ControllerTest.scintillate(:scope => :messages)
    end
    
    describe "an instance" do
      before do
        @ct = ControllerTest.new
      end
      
      it "should be a message queue" do
        @ct.is_a?(Scintillation::MessageQueue).should be_true
      end

      it "should have a scintillation_scope" do
        @ct.scintillation_scope.should == :messages
      end
      
      it "messages should setup the session" do
        @ct.message_store.should == {}
        @ct.session.should == {:messages => {}}
      end
    end
  end
end