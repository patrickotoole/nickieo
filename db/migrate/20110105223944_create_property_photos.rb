class CreatePropertyPhotos < ActiveRecord::Migration
  def self.up
    create_table :property_photos do |t|
      t.integer :property_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :property_photos
  end
end
