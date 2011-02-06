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
end
