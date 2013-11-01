class CreateSexualInfos < ActiveRecord::Migration
  def change
    create_table :sexual_infos do |t|
      t.integer :user_id
      t.integer :sexual_experience, default: 0

      t.timestamps
    end
  end
end
