class CreateBasicInfos < ActiveRecord::Migration
  def change
    create_table :basic_infos do |t|
      t.integer :height, default: 0
      t.integer :body_type, default: 0
      t.integer :weight, default: 0
      t.integer :religion, default: 0
      t.integer :smokes, default: 0
      t.integer :drinks, default: 0
      t.integer :drugs, default: 0

      t.timestamps
    end
  end
end
