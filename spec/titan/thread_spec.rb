require 'spec_helper'

describe Titan::Thread do
  def new_thread(id=nil)
    Titan::Thread.new(:id => id) do
      1+1
    end
  end

  describe "TITAN_FILE" do
    it "should get stored in the home directory" do
      File.dirname(Titan::Thread::TITAN_FILE).should eql(File.expand_path('~'))
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
      Process.should_receive(:fork).and_return(1)
      new_thread
    end

    it "should detach the forked process" do
      Process.should_receive(:detach)
      new_thread
    end

    it "should add the thread to thread management" do
      Titan::Thread.should_receive(:add)
      new_thread
    end

    it "should return a thread" do
      new_thread.should be_a(Titan::Thread)
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

  describe ".add" do
    before(:each) do
      @thread = new_thread
    end

    it "should save the thread with its id" do
      Titan::Thread.add(@thread)
      Titan::Thread.all[@thread.id].should_not be_nil
    end

    it "should save the threads" do
      Titan::Thread.should_receive(:save_threads)
      Titan::Thread.add(@thread)
    end
  end

  describe ".find" do
    before(:each) do
      @thread = new_thread
    end

    it "should return the thread having the given id" do
      Titan::Thread.find(@thread.id).pid.should eql(@thread.pid)
    end
  end

  describe ".kill" do
    before(:each) do
      @thread = new_thread
    end

    it "should send a KILL signal in order to kill the daemond" do
      Process.should_receive(:kill).with('KILL', @thread.pid)
      Titan::Thread.kill(@thread.id)
    end
  end

  describe ".all" do
    before(:each) do
      new_thread
    end

    it "should return an Hash" do
      Titan::Thread.all.should be_an(Hash)
    end
  end

  describe ".load_threads" do
    before(:each) do
      new_thread
    end

    context "TITAN_FILE does not exist" do
      before(:each) do
        File.stub!(:exists?).and_return(false)
      end

      it "should not open any file" do
        File.should_not_receive(:open)
        Titan::Thread.load_threads
      end
    end

    context "TITAN_FILE does exist" do
      before(:each) do
        File.stub!(:exists?).and_return(true)
      end

      it "should open the titan file" do
        File.should_receive(:open).with(Titan::Thread::TITAN_FILE).and_return("")
        Titan::Thread.load_threads
      end

      it "should load threads from the YAML format" do
        YAML.should_receive(:load)
        Titan::Thread.load_threads
      end
    end
  end

  describe ".save_threads" do
    before(:each) do
      new_thread
    end

    it "should write all threads into the titan file" do
      File.should_receive(:open).with(Titan::Thread::TITAN_FILE, 'w')
      Titan::Thread.save_threads
    end

    it "should dump the threads into YAML format" do
      YAML.should_receive(:dump)
      Titan::Thread.save_threads
    end
  end
end
