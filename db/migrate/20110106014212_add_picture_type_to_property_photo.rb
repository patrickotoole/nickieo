class AddPictureTypeToPropertyPhoto < ActiveRecord::Migration
  def self.up
    add_column :property_photos, :picture_type, :string
  end

  def self.down
    remove_column :property_photos, :picture_type
  end
end
