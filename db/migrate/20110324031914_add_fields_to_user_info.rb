class AddFieldsToUserInfo < ActiveRecord::Migration
  def self.up
    add_column :user_infos, :phone, :integer
    add_column :user_infos, :type, :string
  end

  def self.down
    remove_column :user_infos, :type
    remove_column :user_infos, :phone
  end
end
