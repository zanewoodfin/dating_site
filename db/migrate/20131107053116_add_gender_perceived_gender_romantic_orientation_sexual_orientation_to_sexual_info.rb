class AddGenderPerceivedGenderRomanticOrientationSexualOrientationToSexualInfo < ActiveRecord::Migration
  def change
    add_column :sexual_infos, :gender, :integer, default: 0
    add_column :sexual_infos, :perceived_gender, :integer, default: 0
    add_column :sexual_infos, :interested_in, :integer, default: 0
    add_column :sexual_infos, :sexual_orientation, :integer, default: 0
  end
end
