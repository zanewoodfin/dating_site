class CreatePhysicalInfos < ActiveRecord::Migration
  def change
    create_table :physical_infos do |t|
      t.integer :user_id
      t.integer :ethnicity, default: 0
      t.integer :height, default: 0
      t.integer :body_type, default: 0
      t.integer :weight, default: 0
      t.integer :eye_color, default: 0
      t.integer :hair_color, default: 0
      t.integer :body_hair, default: 0

      t.timestamps
    end
  end
end
