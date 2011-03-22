class AddMlsNumberToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :mls_number, :integer
  end

  def self.down
    remove_column :properties, :mls_number
  end
end
