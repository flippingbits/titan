require 'spec_helper'

describe Titan::Thread do
  def new_thread(id=nil)
    Titan::Thread.new(:id => id) do
      1+1
    end
  end

  before(:each) do
    # reset the managed threads
    Titan::Thread.__send__("class_variable_set", "@@threads", {})
  end

  describe "TITAN_DIRECTORY" do
    it "should get stored in the home directory" do
      File.dirname(Titan::Thread::TITAN_DIRECTORY).should eql(File.expand_path('~'))
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
        end.run
        thread.should be_alive
      end
    end

    context "given the thread is not alive" do
      it "should return false" do
        thread = new_thread
        thread.should_not be_alive
      end
    end
  end

  describe "#id=" do
    before(:each) do
      @thread = new_thread
    end

    it "should delete the old thread id from management" do
      id = @thread.id
      @thread.id = "test_id"
      Titan::Thread.all[id].should be_nil
    end

    it "should add the new thread to management" do
      @thread.id = "test_id"
      Titan::Thread.all["test_id"].should_not be_nil
    end

    it "should start the synchronization" do
      Titan::Thread.should_receive(:save_threads)
      @thread.id = "test_id"
    end
  end

  describe "#pid_file" do
    before(:each) do
      @thread = new_thread
    end

    it "should return a file named like its ids" do
      @thread.pid_file.should eql(File.expand_path(@thread.id.to_s + ".pid", Titan::Thread::TITAN_DIRECTORY))
    end
  end

  describe "#save" do
    before(:each) do
      @thread = new_thread
    end

    it "should open its pid file" do
      File.should_receive(:open).with(@thread.pid_file, 'w')
      @thread.save
    end
  end

  describe "#run" do
    it "should fork the current Process" do
      Process.should_receive(:fork).and_return(1)
      new_thread.run
    end

    it "should detach the forked process" do
      Process.should_receive(:detach)
      new_thread.run
    end

    it "should return a thread" do
      new_thread.run.should be_a(Titan::Thread)
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
      File.stub!(:directory?).and_return(true)
      Dir.stub!(:entries).and_return(["test.pid"])
      File.stub!(:read).and_return("12345")
    end

    it "should check the file system" do
      Titan::Thread.should_receive(:check_filesystem)
      Titan::Thread.load_threads
    end

    it "should read the pid files" do
      File.should_receive(:read)
      Titan::Thread.load_threads
    end

    it "should load the threads" do
      Titan::Thread.load_threads
      Titan::Thread.all.should_not be_nil
    end
  end

  describe ".save_threads" do
    before(:each) do
      @first_thread   = new_thread
      @second_thread  = new_thread
    end

    it "should save all threads" do
      [@first_thread, @second_thread].each { |t| t.should_receive(:save) }
      Titan::Thread.save_threads
    end
  end

  describe ".remove_dead_threads" do
    it "should synchronize the threads" do
      Titan::Thread.should_receive(:save_threads)
      Titan::Thread.remove_dead_threads
    end

    it "should return all threads" do
      # avoid initializing a new Hash object
      Titan::Thread.stub!(:load_threads)
      new_thread
      Titan::Thread.remove_dead_threads.should equal(Titan::Thread.all)
    end
  end

  describe ".check_file_system" do
    before(:each) do
      File.stub!(:directory?).and_return(false)
    end

    it "should create the directory" do
      Dir.should_receive(:mkdir).with(Titan::Thread::TITAN_DIRECTORY)
      Titan::Thread.check_filesystem
    end
  end

  describe ".pid_files" do
    it "should return an Array" do
      Titan::Thread.pid_files.should be_an(Array)
    end

    it "should not include ." do
      Titan::Thread.pid_files.should_not include(".")
    end

    it "should not include .." do
      Titan::Thread.pid_files.should_not include("..")
    end
  end
end
