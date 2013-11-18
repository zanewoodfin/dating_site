# == Schema Information
#
# Table name: essay_infos
#
#  id          :integer          not null, primary key
#  about_me    :text             default("")
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  headline    :string(255)
#  looking_for :text
#

class EssayInfo < ActiveRecord::Base
  belongs_to :user

  validates :headline,
    length: 0..50
end
