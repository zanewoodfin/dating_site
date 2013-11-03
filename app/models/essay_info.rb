# == Schema Information
#
# Table name: essays
#
#  id         :integer          not null, primary key
#  about_me   :text             default("")
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class EssayInfo < ActiveRecord::Base
  belongs_to :user
end
