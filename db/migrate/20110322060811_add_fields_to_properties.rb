class AddFieldsToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :property_type, :string
    add_column :properties, :style, :string
    add_column :properties, :stories, :int
    add_column :properties, :occupancy_type, :string
    add_column :properties, :floor, :int
    add_column :properties, :bedrooms, :int
    add_column :properties, :bathrooms, :decimal, :precision => 10, :scale => 1
    add_column :properties, :sqft, :int
    add_column :properties, :lot, :decimal, :precision => 10, :scale => 2
    add_column :properties, :built, :datetime
    add_column :properties, :construction, :string
    add_column :properties, :garage, :string
  end

  def self.down
    remove_column :properties, :built
    remove_column :properties, :garage
    remove_column :properties, :construction
    remove_column :properties, :style
    remove_column :properties, :stories
    remove_column :properties, :floor
    remove_column :properties, :lot
    remove_column :properties, :sqft
    remove_column :properties, :bathrooms
    remove_column :properties, :bedrooms
    remove_column :properties, :occupancy_type
    remove_column :properties, :property_type
  end
end
