class AddNewToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :new, :boolean, default: true
  end
end
