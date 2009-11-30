# wrapping class to hold an flickr group
class Flickr::Groups::Group
  attr_accessor :nsid, :name, :eighteenplus # standard attributes
  attr_accessor :icon_farm, :icon_server # extra attributes
  attr_accessor :info_added, :description, :member_count # info attributes
  
  # create a new instance of a flickr group.
  # 
  # Params
  # * flickr (Required)
  #     the flickr object
  # * attributes (Required)
  #     a hash of attributes used to set the initial values of the group object
  def initialize(flickr, attributes)
    @flickr = flickr
    attributes.each do |k,v|
      send("#{k}=", v)
    end
  end

  # The groups icon image
  def buddy_icon
    attach_info
    @buddy_icon ||= if icon_server.to_i > 0
                      "http://farm#{icon_farm}.static.flickr.com/#{icon_server}/buddyicons/#{nsid}.jpg"
                    else
                      'http://www.flickr.com/images/buddyicon.jpg'
                    end
  end
  

  # The number of members in the group
  def member_count
    attach_info
    @member_count
  end

  # The groups url
  def group_url
    Flickr::Urls.new(@flickr).get_group(self.nsid)
  end

  # Alias to group_url
  def url
    group_url()
  end
  
  # The groups description
  def description
    attach_info
    @description
  end

  protected

  # loads group info when a field is requested that requires additional info
  def attach_info # :nodoc:
    unless self.info_added
      rsp = @flickr.send_request('flickr.groups.getInfo', :group_id => self.nsid)
      self.info_added = true
      self.description = rsp.group.description.to_s.strip
      self.member_count = rsp.group.members.to_s.strip
      self.icon_server = rsp.group[:iconserver]
      self.icon_farm = rsp.group[:iconfarm]
    end
  end
end
