class AddDescriptionToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :price, :int
    add_column :properties, :description, :text
    add_column :properties, :headline, :text
  end

  def self.down
    remove_column :properties, :headline
    remove_column :properties, :description
    remove_column :properties, :price
  end
end
