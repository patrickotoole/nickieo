class AddLatLngToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :lat, :decimal, :precision => 16, :scale => 8
    add_column :properties, :lng, :decimal, :precision => 16, :scale => 8
  end

  def self.down
    remove_column :properties, :lat
    remove_column :properties, :lng
  end
end
