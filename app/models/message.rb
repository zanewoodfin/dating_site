# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  content      :text
#  created_at   :datetime
#  updated_at   :datetime
#

class Message < ActiveRecord::Base
  attr_accessor :recipient_username

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_validation :set_recipient

  validates_presence_of :sender, :recipient, :content
  validate :sender_does_not_equal_recipient

  def other_person(user)
    sender == user ? recipient : sender
  end

private

  def set_recipient
    self.recipient_id = User.where(username: recipient_username).first.id unless self.recipient_id
  end

  def sender_does_not_equal_recipient
    self.errors.add(:base, 'cannot message yourself') if :sender == :recipient
  end

end
