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
#  new           :boolean          default(TRUE)
#

class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_uniqueness_of :user_id, scope: [:likeable_id, :likeable_type]
  validate :likeable_user

  private

  def likeable_user
    if likeable_type == 'User'
      liker_does_not_equal_liked
      liker_not_blocked
    end
  end

  def liker_does_not_equal_liked
    errors.add(:base, 'cannot like yourself') if user_id == likeable_id
  end

  def liker_not_blocked
    blocked = User.find(likeable_id).blocked
    errors.add(:base, 'this user has blocked you') if blocked.include? user
  end
end
