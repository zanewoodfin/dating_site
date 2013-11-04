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
  validate :sender_not_blocked

  def other_person(user)
    sender == user ? recipient : sender
  end

  def remove_user(user)
    self.removed_by_sender = true if user == sender
    self.removed_by_recipient = true if user == recipient
    if removed_by_sender && removed_by_recipient
      self.destroy
    else
      self.save
    end
  end
  def self.remove_user(user, contacts)
    where(sender_id: user.id, recipient_id: contacts).update_all(removed_by_sender: true)
    where(recipient_id: user.id, sender_id: contacts).update_all(removed_by_recipient: true)
    where(removed_by_sender: true, removed_by_recipient: true).delete_all
  end

private

  def set_recipient
    self.recipient_id = User.where(username: recipient_username).first.id unless self.recipient_id
  end

  def sender_does_not_equal_recipient
    self.errors.add(:base, 'cannot message yourself') if :sender == :recipient
  end

  def sender_not_blocked
    self.errors.add(:base, 'this user has blocked you') if recipient.blocked.include? sender
  end

end
