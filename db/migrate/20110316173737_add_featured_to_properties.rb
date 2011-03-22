class AddFeaturedToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :featured, :boolean
  end

  def self.down
    remove_column :properties, :featured
  end
end
