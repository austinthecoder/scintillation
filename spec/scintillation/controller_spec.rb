require 'spec_helper'
require 'action_controller'

class ControllerTest < ActionController::Base
  extend Scintillation::Controller
  
  def session
    @session ||= {}
  end
end

describe ControllerTest do
  
  describe ".scintillate" do
    [Scintillation::MessageQueue, Scintillation::Controller::InstanceMethods].each do |mod|
      it "should include the #{mod.inspect} module" do
        ControllerTest.scintillate
        ControllerTest.include?(mod).should be_true
      end
    end
    
    it "should include the Scintillation::View module into ActionView::Base" do
      ControllerTest.scintillate
      ActionView::Base.include?(Scintillation::View).should be_true
    end
    
    it "should specify a helper method" do
      ControllerTest.should_receive(:helper_method).with(:message_store)
      ControllerTest.scintillate
    end
    
    context "when no scope is given" do
      it "should create an instance method called scintillation_scope that returns :messages" do
        ControllerTest.scintillate
        ControllerTest.new.scintillation_scope.should == :messages
      end
    end
    
    [nil, "my scope"].each do |scope|
      context "when given the scope is #{scope.inspect}" do
        it "should create an instance method called scintillation_scope that returns #{scope.inspect}" do
          ControllerTest.scintillate(:scope => scope)
          ControllerTest.new.scintillation_scope.should == scope
        end
      end
    end
  end
  
  describe "#message_store" do
    before do
      ControllerTest.scintillate
      @ct = ControllerTest.new
    end
    
    it "should return the value when the session has a key matching the scintillation_scope" do
      @ct.session[@ct.scintillation_scope] = [1, 2]
      @ct.message_store.should == [1, 2]
    end
    
    it "should return an empty hash when the session doesn't have a key matching the scintillation_scope" do
      @ct.message_store.should == {}
    end
  end
  
end