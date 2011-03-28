class CreateSavedProperties < ActiveRecord::Migration
  def self.up
    create_table :saved_properties do |t|
      t.integer :user_id
      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :saved_properties
  end
end
