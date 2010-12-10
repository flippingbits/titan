require 'spec_helper'

describe Titan::CLI do
  before(:each) do
    @shell = mock(Thor::Shell::Basic, :print_table => nil, :say => nil)
    Thor::Shell::Basic.stub!(:new).and_return(@shell)
    @cli = Titan::CLI.new
  end

  describe "#help" do
    it "should print the methods as a table" do
     @shell.should_receive(:print_table)
     @cli.help
    end
  end

  describe "#status" do
    it "should load all threads" do
      Titan::Thread.should_receive(:all).and_return({})
      @cli.status
    end

    context "given there are threads available" do
      before(:each) do
        Titan::Thread.stub!(:all).and_return({'test' => Titan::Thread.new(:id => 'test')})
      end

      it "should print the threads as a table" do
        @shell.should_receive(:print_table)
        @cli.status
      end
    end

    context "given there are no threads available" do
      before(:each) do
        Titan::Thread.stub!(:all).and_return({})
      end

      it "should not print the threads as a table" do
        @shell.should_not_receive(:print_table)
        @cli.status
      end
    end
  end
end
