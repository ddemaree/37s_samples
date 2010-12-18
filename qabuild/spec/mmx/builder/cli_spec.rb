require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MMX::Builder::CLI do
  describe "run!" do
    subject { MMX::Builder::CLI.new(['whatever']) }
      
    it "should suppress MMX::Builder::Commands::BadCommandError and display it as output, end program" do
      subject.stub!(:run_command!).and_raise(MMX::Builder::Commands::BadCommandError.new "Oh noes!")
      subject.should_receive(:puts).with("ERROR: Oh noes!")
      subject.run!
    end
    
    it "should not suppress other errors" do
      subject.stub!(:run_command!).and_raise(StandardError)
      lambda do
        subject.run!
      end.should raise_error(StandardError)
    end
  end
  
  describe "run_command!" do
    context "bad command" do
      subject { MMX::Builder::CLI.new(["bogus"]) }
      
      it "should raise an MMX::Builder::Commands::BadCommandError" do
        lambda do
          subject.run_command!
        end.should raise_error(MMX::Builder::Commands::BadCommandError)
      end
    end
    
    context "help command" do
      subject { MMX::Builder::CLI.new(["--help"]) }
      
      it "should display the help message" do
        subject.should_receive(:display_help)
        subject.run_command!
      end
    end
    
    context "version command" do
      subject { MMX::Builder::CLI.new(["--version"]) }
      
      it "should display the version message" do
        subject.should_receive(:puts).with("Metromix QA Build Tool version #{MMX::Builder::VERSION}")
        subject.run_command!
      end
    end
    
    context "status command" do
      subject { MMX::Builder::CLI.new(["status", 'arg1', 'arg2']) }
      
      it "should instantiate and run a Status object" do
        status = mock("status object")
        status.should_receive(:run!)
        MMX::Builder::Commands::Status.should_receive(:new).with(['arg1', 'arg2']).and_return(status)
        subject.run_command!
      end
    end
    
    context "build command" do
      subject { MMX::Builder::CLI.new(["build", 'arg1', 'arg2']) }
      
      it "should raise a deprecation error" do
        lambda do
          subject.run_command!
        end.should raise_error(MMX::Builder::Commands::DeprecationError)
      end
    end
    
    context "rebuild command" do
      subject { MMX::Builder::CLI.new(["rebuild", 'arg1', 'arg2']) }
      
      it "should instantiate and run a Rebuild object" do
        rebuild = mock("rebuild object")
        rebuild.should_receive(:run!)
        MMX::Builder::Commands::Rebuild.should_receive(:new).with(['arg1', 'arg2']).and_return(rebuild)
        subject.run_command!
      end
    end
    
    context "change command" do
      subject { MMX::Builder::CLI.new(["change", 'arg1', 'arg2']) }
      
      it "should instantiate and run a Change object" do
        change = mock("change object")
        change.should_receive(:run!)
        MMX::Builder::Commands::Change.should_receive(:new).with(['arg1', 'arg2']).and_return(change)
        subject.run_command!
      end
    end
  end
end