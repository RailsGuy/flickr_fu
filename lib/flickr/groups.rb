class Flickr::Groups < Flickr::Base
  def initialize(flickr)
    @flickr = flickr
  end

  # Return a list of groups matching some criteria. 
  # 
  # == Authentication
  # This method does not require authentication.
  # 18+ groups will only be returned for authenticated calls where the authenticated user is over 18.
  #
  # == Options
  # * text (Required)
  #     A free text search. Groups who's name contains the text will be returned.
  # * per_page (Optional)
  #     Number of groups to return per page. If this argument is omitted, it defaults to 100. The maximum allowed value is 500.
  # * page (Optional)
  #     The page of results to return. If this argument is omitted, it defaults to 1.
  # 
  def search(options)
    rsp = @flickr.send_request('flickr.groups.search', options)
    
    returning Flickr::FlickrResponse.new(:page => rsp.groups[:page].to_i,
                                         :pages => rsp.groups[:pages].to_i,
                                         :per_page => rsp.groups[:perpage].to_i,
                                         :total => rsp.groups[:total].to_i,
                                         :objects => [],
                                         :api => self,
                                         :method => :search,
                                         :options => options) do |groups|
      rsp.groups.group.each do |group|
        attributes = create_attributes(group)

        groups << Group.new(@flickr, attributes)
      end if rsp.groups.group
    end
  end
  
  # Return a list of group members
  # 
  # == Authentication
  # This method does not require authentication.
  #
  # == Options
  # * group_id (Required)
  #
  # * per_page (Optional)
  #     Number of members to return per page. If this argument is omitted, it defaults to 100. The maximum allowed value is 500.
  # * page (Optional)
  #     The page of results to return. If this argument is omitted, it defaults to 1.
  # 
  # def members(options)
  #   rsp = @flickr.send_request('flickr.groups.members.getList', options)
  #   TODO
  # end
  
    
  protected
  
  def create_attributes(group) # :nodoc:
    {:nsid => group[:nsid], 
     :name => group[:name],
     :eighteenplus => group[:eighteenplus]}
  end
  
end
