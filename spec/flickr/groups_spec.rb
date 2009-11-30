require File.dirname(__FILE__) + '/../spec_helper'

describe Flickr::Groups do
  
  before :each do
    @flickr = SpecHelper.flickr
  end
  
  describe ".search" do
    before(:each) do
      groups_xml = File.read(File.dirname(__FILE__) + "/../fixtures/flickr/groups/get_list-0.xml")
      @flickr.should_receive(:request_over_http).and_return(groups_xml)
    end

    it "should return groups when search text is given" do
      groups = @flickr.groups.search(:text => 'Test')
      groups.should be_instance_of(Flickr::FlickrResponse)
      groups.first.should be_instance_of(Flickr::Groups::Group)
    end
    
    it "should return one group object per group element" do
      pending
    end
    
    it "should raise an error when no search text is given" do
      pending
      # proc { groups = @flickr.groups.search(:text => '') }.should raise_error
    end
    
  end
end