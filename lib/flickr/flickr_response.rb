# wrapping class to hold a collection response from the flickr api
#
class Flickr::FlickrResponse
  attr_accessor :page, :pages, :per_page, :total, :objects, :api, :method, :options
  
  # creates an object to hold the search response.
  # 
  # Params
  # * attributes (Required)
  #     a hash of attributes used to set the initial values of the response object
  def initialize(attributes)
    attributes.each do |k,v|
      send("#{k}=", v)
    end
  end

  # Add a Flickr object to the objects array.
  def <<(object)
    self.objects ||= []
    self.objects << object
  end

  # gets the next page from flickr if there are anymore pages in the current objects object
  def next_page
    api.send(self.method, options.merge(:page => self.page.to_i + 1)) if self.page.to_i < self.pages.to_i
  end
  
  # gets the previous page from flickr if there is a previous page in the current objects object
  def previous_page
    api.send(self.method, options.merge(:page => self.page.to_i - 1)) if self.page.to_i > 1
  end
  # 
  # passes all unknown request to the objects array if it responds to the method
  def method_missing(method, *args, &block)
    self.objects.respond_to?(method) ? self.objects.send(method, *args, &block) : super
  end
  
  # Total pages returned
  def total_pages
    self.pages
  end
  
  # Alias page
  def current_page
    self.page
  end
end