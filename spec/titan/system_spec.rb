require 'spec_helper'

describe Titan::System do
  describe ".ps" do
    context "given a pid that is greater than 0" do
      it "should return a String" do
        Titan::System.ps('rss', 1).should be_a(String)
      end
    end

    context "given a pid that is equal 0" do
      it "should return nil" do
        Titan::System.ps('rss', 0).should be_nil
      end
    end
  end

  describe ".check_file_system" do
    before(:each) do
      File.stub!(:directory?).and_return(false)
    end

    it "should create the directory" do
      Dir.should_receive(:mkdir).with(Titan::TITAN_DIRECTORY)
      Titan::System.check_filesystem
    end
  end

  describe ".pid_files" do
    it "should return an Array" do
      Titan::System.pid_files.should be_an(Array)
    end

    it "should not include ." do
      Titan::System.pid_files.should_not include(".")
    end

    it "should not include .." do
      Titan::System.pid_files.should_not include("..")
    end
  end
end
