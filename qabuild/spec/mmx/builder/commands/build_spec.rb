require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe MMX::Builder::Commands::Build do
  describe "project_names" do
    it "should return all the names of the projects" do
      expected = %w{affiliate express deals_mgmt deals urn_identifiable}
      MMX::Builder::Commands::Build.new.project_names.should == expected
    end
  end

  describe "host_prefixes" do
    it "should return all the qa host prefixes" do
      expected = %w{qa01 qa02 qa03 qa04}
      MMX::Builder::Commands::Build.new.host_prefixes.should == expected
    end
  end
  
  describe "run!" do
    subject { MMX::Builder::Commands::Build.new(['affiliate', 'qa01', 'my_branch']) }
    
    before(:each) do
      subject.stub!(:validate_args!)
      subject.stub!(:build!)
    end
    
    it "should validate args" do
      subject.should_receive(:validate_args!)
      subject.run!
    end
    
    it "should do the build" do
      subject.should_receive(:build!)
      subject.run!
    end
  end
  
  describe "validate_args!" do
    context "with --help option" do
      subject { MMX::Builder::Commands::Build.new(['--help']) }
      
      before(:each) do
        subject.stub!(:validate_project_name!)
        subject.stub!(:validate_host_prefix!)
      end
      
      it "should display_help" do
        subject.should_receive(:display_help)
        subject.validate_args!
      end
    end
    
    context "with valid args" do
      subject { MMX::Builder::Commands::Build.new(['affiliate', 'qa01', 'my_branch']) }
      before(:each) { subject.validate_args!}
      
      it "should set the project_name" do
        subject.project_name.should == "affiliate"
      end
      
      it "should set the host_prefix" do
        subject.host_prefix.should == 'qa01'
      end
      
      it "should set the branch_name" do
        subject.branch_name.should == 'my_branch'
      end
    end
    
    context "with invalid project_name" do
      subject { MMX::Builder::Commands::Build.new(['bogus', 'qa01']) }
      
      it "should raise an MMX::Builder::Commands::BadCommandError" do
        lambda {
          subject.validate_args!
        }.should raise_error(MMX::Builder::Commands::BadCommandError)
      end
    end
    
    context "with invalid host_prefix" do
      subject { MMX::Builder::Commands::Build.new(['affiliate', 'bogus']) }
      
      it "should raise an MMX::Builder::Commands::BadCommandError" do
        lambda {
          subject.validate_args!
        }.should raise_error(MMX::Builder::Commands::BadCommandError)
      end
    end
  end
end