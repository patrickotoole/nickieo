class Property < ActiveRecord::Base
  acts_as_mappable
  has_many :property_photos
  has_many :saved_properties
  has_many :users, :through => :saved_properties
  
  def set_lat_lng(hash)
    address_s = self.address.to_s + ", " + self.city.to_s + ", " + self.state.to_s
    loc = GeoKit::Geocoders::MultiGeocoder.geocode(address_s)

    Rails.logger.debug loc.lat

    self.lat = loc.lat
    self.lng = loc.lng
    
    if hash 
      hash[:lat] = loc.lat
      hash[:lng] = loc.lng
    end
  end
end
