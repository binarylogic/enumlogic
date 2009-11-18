require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Enumlogic" do
  it "should have a constant" do
    Computer.enum :kind, ["apple", "dell", "hp"], :namespace => true
    Computer::KINDS.should == ["apple", "dell", "hp"]
  end
  
  it "constant should always return an array" do
    hash = ActiveSupport::OrderedHash.new
    hash["apple"] = "Apple"
    hash["dell"] = "Dell"
    hash["hp"] = "HP"
    
    Computer.enum :kind, hash, :namespace => true
    Computer::KINDS.should == ["apple", "dell", "hp"]
  end
  
  it "should create a class level options method" do
    Computer.enum :kind, ["apple", "dell", "hp"]
    Computer.kind_options.should == {"apple" => "apple", "dell" => "dell", "hp" => "hp"}
  end
  
  it "should create a class level options method for hashes" do
    Computer.enum :kind, {"apple" => "Apple", "dell" => "Dell", "hp" => "HP"}
    Computer.kind_options.should == {"Apple" => "apple", "Dell" => "dell", "HP" => "hp"}
  end
  
  it "should create key methods" do
    Computer.enum :kind, ["apple", "dell", "hp"]
    c = Computer.new(:kind => "apple")
    c.kind_key.should == :apple
  end
  
  it "should create key methods for hashes" do
    Computer.enum :kind, {"apple" => "Apple", "dell" => "Dell", "hp" => "HP"}
    c = Computer.new(:kind => "apple")
    c.kind_key.should == :apple
  end
  
  it "should create text methods" do
    Computer.enum :kind, {"apple" => "Apple", "dell" => "Dell", "hp" => "HP"}
    c = Computer.new(:kind => "hp")
    c.kind_text.should == "HP"
  end
  
  it "should create text methods for hashes" do
    Computer.enum :kind, {"apple" => "Apple", "dell" => "Dell", "hp" => "HP"}
    c = Computer.new(:kind => "hp")
    c.kind_text.should == "HP"
  end

  it "should create text method which results nil for wrong key" do
    Computer.enum :kind, {"apple" => "Apple", "dell" => "Dell", "hp" => "HP"}
    c = Computer.new :kind => 'ibm'
    c.kind_text.should == nil
  end
  
  it "should create boolean methods" do
    Computer.enum :kind, ["apple", "dell", "hp"]
    c = Computer.new(:kind => "apple")
    c.should be_apple
  end
  
  it "should namespace boolean methods" do
    Computer.enum :kind, ["apple", "dell", "hp"], :namespace => true
    c = Computer.new(:kind => "apple")
    c.should be_apple_kind
  end
  
  it "should validate inclusion" do
    Computer.enum :kind, ["apple", "dell", "hp"]
    c = Computer.new
    c.kind = "blah"
    c.should_not be_valid
    c.errors[:kind].should include("is not included in the list")
  end
  
  it "should allow nil during validations" do
    Computer.enum :kind, ["apple", "dell", "hp"], :allow_nil => true
    c = Computer.new
    c.should be_valid
  end
  
  it "should implement the if option during validation" do
    Computer.enum :kind, ["apple", "dell", "hp"], :if => :return_false
    c = Computer.new
    c.should be_valid
  end
  
  it "should be included in the list" do
    Computer.enum :kind, ["apple", "dell", "hp", "custom made"]
    c = Computer.new(:kind => "custom made")
    c.should be_valid
  end
  
  it "should find a defined enum" do
    Computer.enum :kind, ["apple", "dell", "hp"]
    
    Computer.enum?(:kind).should == true
    Computer.enum?(:some_other_field).should == false
  end
  
  it "should check for defined enums if there isn't any" do
    Computer.enum?(:kind).should == false
  end
end