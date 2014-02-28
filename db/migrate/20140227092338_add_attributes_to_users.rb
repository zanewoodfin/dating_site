class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :religion, :integer, default: 0
    add_column :users, :smokes, :integer, default: 0
    add_column :users, :drinks, :integer, default: 0
    add_column :users, :drugs, :integer, default: 0
    add_column :users, :political_orientation, :integer, default: 0
    add_column :users, :diet, :integer, default: 0
    add_column :users, :ethnicity, :integer, default: 0
    add_column :users, :height, :integer, default: 0
    add_column :users, :body_type, :integer, default: 0
    add_column :users, :eye_color, :integer, default: 0
    add_column :users, :hair_color, :integer, default: 0
    add_column :users, :headline, :string, default: ''
    add_column :users, :about_me, :text, default: ''
    add_column :users, :looking_for, :text, default: ''
  end
end
