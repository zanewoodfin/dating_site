class AddHeadlineToEssayInfos < ActiveRecord::Migration
  def change
    add_column :essay_infos, :headline, :string
  end
end
