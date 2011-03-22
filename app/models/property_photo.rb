class PropertyPhoto < ActiveRecord::Base
  belongs_to :property
  mount_uploader :url, ImageUploader
  
end
