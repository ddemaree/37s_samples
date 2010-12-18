require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe MMX::Builder::Commands::Change do
  describe "run!" do
    it "should build and run a Change object with the project_name and host_prefix" do
      build = mock("build object")
      MMX::Builder::Commands::Build.should_receive(:new).with(['affiliate', 'qa01', 'new_branch']).and_return(build)
      build.should_receive(:run!)
      MMX::Builder::Commands::Change.new(['affiliate', 'qa01', 'new_branch']).run!
    end
    
    it "should raise an error if branch is missing before initializing the build" do
      MMX::Builder::Commands::Build.should_not_receive(:new)
      lambda do
        MMX::Builder::Commands::Change.new(['affiliate', 'qa01']).run!
      end.should raise_error(MMX::Builder::Commands::BadCommandError)
    end
  end
end