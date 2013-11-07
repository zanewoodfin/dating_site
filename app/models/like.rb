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
  validate :liker_does_not_equal_liked
  validate :liker_not_blocked

private

  def liker_does_not_equal_liked
    if likeable_type == 'User'
      self.errors.add(:base, 'cannot like yourself') if user_id == likeable_id
    end
  end

  def liker_not_blocked
    if likeable_type == 'User'
      liked = User.find(likeable_id)
      puts "liked:#{liked.id} user:#{user.id}"
      self.errors.add(:base, 'this user has blocked you') if liked.blocked.include? user
    end
  end

end

