# == Schema Information
#
# Table name: messages
#
#  id                   :integer          not null, primary key
#  sender_id            :integer
#  recipient_id         :integer
#  content              :text
#  created_at           :datetime
#  updated_at           :datetime
#  removed_by_sender    :boolean          default(FALSE)
#  removed_by_recipient :boolean          default(FALSE)
#  read                 :boolean          default(FALSE)
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
    removed_by_sender = true if user == sender
    removed_by_recipient = true if user == recipient
    removed_by_sender && removed_by_recipient ? destroy : save
  end

  def self.remove_user(user, contacts)
    where(sender_id: user.id, recipient_id: contacts)
      .update_all(removed_by_sender: true)
    where(recipient_id: user.id, sender_id: contacts)
      .update_all(removed_by_recipient: true)
    where(removed_by_sender: true, removed_by_recipient: true).delete_all
  end

  private

  def set_recipient
    self.recipient = User.find_by_username(recipient_username) unless recipient
  end

  def sender_does_not_equal_recipient
    errors.add(:base, 'cannot message yourself') if :sender == :recipient
  end

  def sender_not_blocked
    if recipient.blocked.include? sender
      errors.add(:base, 'this user has blocked you')
    end
  end
end
