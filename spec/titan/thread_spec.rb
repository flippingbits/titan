require 'spec_helper'

describe Titan::Thread do
  def new_thread(id=nil)
    Titan::Thread.new(:id => id) do
      1+1
    end
  end

  describe "#initialize" do
    context "given a id" do
      before(:each) do
        @id = 123
        @thread = new_thread(@id)
      end

      it "should use the id" do
        @thread.id.should eql(@id)
      end
    end

    context "given no id" do
      before(:each) do
        @thread = new_thread
      end

      it "should use the object id as id" do
        @thread.id.should eql(@thread.object_id)
      end
    end

    it "should fork the current Process" do
      Process.should_receive(:fork)
      @thread = new_thread
    end

    it "should detach the forked process" do
      Process.should_receive(:detach)
      @thread = new_thread
    end

    it "should trap the HUP and IGNORE signals" do
      Signal.should_receive(:trap).with('HUP', 'IGNORE')
      @thread = new_thread
    end
  end

  describe "#kill" do
    before(:each) do
      @thread = new_thread
    end

    it "should send a KILL signal to the process" do
      Process.should_receive(:kill).with('KILL', @thread.pid)
      @thread.kill
    end
  end

  describe "#alive?" do
    context "given the thread is alive" do
      it "should return true" do
        thread = Titan::Thread.new do
          sleep(1)
        end
        thread.should be_alive
      end
    end

    context "given the thread is not alive" do
      it "should return false" do
        thread = new_thread
        sleep(1)
        thread.should_not be_alive
      end
    end
  end
end
