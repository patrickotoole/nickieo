class AddNameToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :name, :string
  end

  def self.down
    remove_column :preferences, :name
  end
end
