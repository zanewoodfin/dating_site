# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # constants
  WORD_CHARS = /\A\w+\z/

  # username validations
  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: 3..20,
    format: { with: WORD_CHARS }

  # likes me
  has_many :liked_by, class_name: 'Like', as: :likeable, dependent: :destroy
  has_many :likes_me, through: :liked_by, source: :user

  # I like
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :likeable, source_type: 'User'

  # blocked users
  has_many :blocked_users, dependent: :destroy
  has_many :blocked, through: :blocked_users

  # blocking users
  has_many :blocking_users, class_name: 'BlockedUser',  foreign_key: :blocked_id, dependent: :destroy
  has_many :blocked_by, through: :blocking_users, source: :user

  # messages
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :recipients, through: :sent_messages
  has_many :received_messages, class_name: 'Message', foreign_key: :recipient_id
  has_many :senders, through: :received_messages

  # pics
  has_many :pics

  # info
  has_one :physical_info, dependent: :destroy
  has_one :sexual_info, dependent: :destroy
  has_one :social_info, dependent: :destroy
  has_one :essay_info, dependent: :destroy

  def pool
    User.where.not(id: blocked + blocked_by << id)
  end

  def default_pic(type = false)
    args = [:image_url]
    args << type if type
    pics.first.try(*args) || 'default_person.jpeg'
  end

  def contacts
    senders = received_messages.where(removed_by_recipient: false).map { |m| m.sender }
    recipients = sent_messages.where(removed_by_sender: false).map { |m| m.recipient }
    people = senders + recipients
    people ? people.uniq : []
  end

  def unread_message_count
    received_messages.where(read: false).count
  end

  def last_activity
    current_time = DateTime.now
    "last activity: " +
      if updated_at > current_time - 1.minute
        "now"
      elsif updated_at > current_time - 1.hour
        pluralize(((current_time.to_i - updated_at.to_i) / 60), 'minute') + " ago"
      elsif updated_at > current_time - 1.day
        pluralize(((current_time.to_i - updated_at.to_i) / 3600), 'hour') + " ago"
      else
        pluralize(((current_time.to_i - updated_at.to_i) / 86400), 'day') + " ago"
      end
  end

  def new_blockers_count
    blocking_users.where(new: true).count
  end

  def new_likers_count
    liked_by.where(new: true).count
  end

private

  def pluralize(number, word)
    "#{ number.to_s } #{ word }" + ((number > 1) ? "s" : "")
  end

end

