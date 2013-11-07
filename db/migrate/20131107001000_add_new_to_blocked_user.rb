class AddNewToBlockedUser < ActiveRecord::Migration
  def change
    add_column :blocked_users, :new, :boolean, default: true
  end
end
