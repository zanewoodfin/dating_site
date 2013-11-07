# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  likeable_id   :integer
#  likeable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_uniqueness_of :user_id, scope: [:likeable_id, :likeable_type]
end
