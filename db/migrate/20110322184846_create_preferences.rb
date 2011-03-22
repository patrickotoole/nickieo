class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :user_id
      t.integer :min_price
      t.integer :max_price
      t.integer :min_sqft
      t.integer :max_sqft
      t.integer :min_bedrooms
      t.integer :max_bedrooms
      t.integer :min_bathrooms
      t.integer :max_bathroom
      t.string :property_type

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
