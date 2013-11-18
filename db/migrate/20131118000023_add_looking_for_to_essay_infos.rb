class AddLookingForToEssayInfos < ActiveRecord::Migration
  def change
    add_column :essay_infos, :looking_for, :text, default: ''
  end
end
