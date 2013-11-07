class AddPoliticalOrientationAndDietToSocialInfo < ActiveRecord::Migration
  def change
    add_column :social_infos, :political_orientation, :integer, default: 0
    add_column :social_infos, :diet, :integer, default: 0
  end
end
