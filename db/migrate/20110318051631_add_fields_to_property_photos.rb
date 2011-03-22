class AddFieldsToPropertyPhotos < ActiveRecord::Migration
  def self.up
    add_column :property_photos, :order, :int
    add_column :property_photos, :description, :text
    add_column :property_photos, :caption, :text
  end

  def self.down
    remove_column :property_photos, :caption
    remove_column :property_photos, :description
    remove_column :property_photos, :order
  end
end
