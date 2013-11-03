# == Schema Information
#
# Table name: blocked_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  blocked_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class BlockedUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :blocked, class_name: "User"

  validates_uniqueness_of :blocked, scope: :user
  validate :user_does_not_equal_blocked

private

  def user_does_not_equal_blocked
    self.errors.add(:base, 'cannot block yourself') if :user == :blocked
  end
end
