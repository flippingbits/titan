require 'spec_helper'

describe Titan::Manager do
  def new_thread(id = nil)
    Titan::Thread.new do
      1+1
    end
  end

  def setup_manager
    @manager = Titan::Manager.new
    @thread = new_thread
    @manager.attach(@thread)
  end

  describe "TITAN_FILE" do
    it "should get stored in the home directory" do
      File.dirname(Titan::Manager::TITAN_FILE).should eql(File.expand_path('~'))
    end
  end

  describe "#attach" do
    before(:each) do
      @manager = Titan::Manager.new
      @thread = new_thread
    end

    it "should save the thread with its id" do
      @manager.attach(@thread)
      @manager.instance_variable_get("@threads")[@thread.id].should_not be_nil
    end

    it "should save the threads" do
      @manager.should_receive(:save_threads)
      @manager.attach(@thread)
    end
  end

  describe "#find" do
    before(:each) do
      setup_manager
    end

    it "should return the thread having the given id" do
      @manager.find(@thread.id).should eql(@thread)
    end
  end

  describe "#kill" do
    before(:each) do
      setup_manager
    end

    it "should send a KILL signal in order to kill the daemond" do
      Process.should_receive(:kill).with('KILL', @thread)
      @manager.kill(@thread.id)
    end
  end

  describe "#all_threads" do
    before(:each) do
      setup_manager
    end

    it "should return an Hash" do
      @manager.all_threads
    end
  end

  describe "#load_threads" do
    before(:each) do
      setup_manager
    end

    context "TITAN_FILE does not exist" do
      before(:each) do
        File.stub!(:exists?).and_return(false)
      end

      it "should not open any file" do
        File.should_not_receive(:open)
        @manager.load_threads
      end
    end

    context "TITAN_FILE does exist" do
      before(:each) do
        File.stub!(:exists?).and_return(true)
      end

      it "should open the titan file" do
        File.should_receive(:open).with(Titan::Manager::TITAN_FILE).and_return("")
        @manager.load_threads
      end

      it "should load threads from the YAML format" do
        YAML.should_receive(:load)
        @manager.load_threads
      end
    end
  end

  describe "#save_threads" do
    before(:each) do
      setup_manager
    end

    it "should write all threads into the titan file" do
      File.should_receive(:open).with(Titan::Manager::TITAN_FILE, 'w')
      @manager.save_threads
    end

    it "should dump the threads into YAML format" do
      YAML.should_receive(:dump)
      @manager.save_threads
    end
  end
end
