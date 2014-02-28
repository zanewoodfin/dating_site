class DropAttributeTables < ActiveRecord::Migration
  def up
    drop_table :social_infos
    drop_table :physical_infos
    drop_table :sexual_infos
    drop_table :essay_infos
  end

  def down
    create_table :social_infos do |t|
      t.integer :user_id
      t.integer :religion, default: 0
      t.integer :smokes, default: 0
      t.integer :drinks, default: 0
      t.integer :drugs, default: 0
      t.integer :political_orientation, default: 0
      t.integer :diet, default: 0

      t.timestamps
    end
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
    create_table :sexual_infos do |t|
      t.integer :user_id
      t.integer :sexual_experience, default: 0
      t.integer :gender, default: 0
      t.integer :perceived_gender, default: 0
      t.integer :interested_in, default: 0
      t.integer :sexual_orientation, default: 0

      t.timestamps
    end
    create_table :essay_infos do |t|
      t.string :headline, default: ''
      t.text :about_me, default: ''
      t.text :looking_for, default: ''
      t.integer :user_id

      t.timestamps
    end
  end
end
