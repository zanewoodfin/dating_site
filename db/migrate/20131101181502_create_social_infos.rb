class CreateSocialInfos < ActiveRecord::Migration
  def change
    create_table :social_infos do |t|
      t.integer :user_id
      t.integer :religion, default: 0
      t.integer :smokes, default: 0
      t.integer :drinks, default: 0
      t.integer :drugs, default: 0

      t.timestamps
    end
  end
end
