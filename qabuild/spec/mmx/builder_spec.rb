require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MMX::Builder do
  describe "build_root" do
    it "should return something" do
      MMX::Builder.build_root.should_not be_nil
    end
  end
end