require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe MMX::Builder::Commands::Rebuild do
  before(:each) do
    MMX::Builder::Commands::Build.stub!(:new)
  end
  
  describe "run" do
    it "should build and run a Build object with the project_name and host_prefix" do
      build = mock("build object")
      MMX::Builder::Commands::Build.should_receive(:new).with(['affiliate', 'qa01']).and_return(build)
      build.should_receive(:run!)
      MMX::Builder::Commands::Rebuild.new(['affiliate', 'qa01']).run!
    end
    
    it "should raise before building if called with a branch name" do
      MMX::Builder::Commands::Build.should_not_receive(:new)
      lambda do
        MMX::Builder::Commands::Rebuild.new(['affiliate', 'qa01', 'branch']).run!
      end.should raise_error(MMX::Builder::Commands::BadCommandError)
    end
  end
end