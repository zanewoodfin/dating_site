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
#  zip_code               :string(255)
#  latitude               :float
#  longitude              :float
#  birthday               :datetime
#  religion               :integer          default(0)
#  smokes                 :integer          default(0)
#  drinks                 :integer          default(0)
#  drugs                  :integer          default(0)
#  political_orientation  :integer          default(0)
#  diet                   :integer          default(0)
#  ethnicity              :integer          default(0)
#  height                 :integer          default(0)
#  body_type              :integer          default(0)
#  eye_color              :integer          default(0)
#  hair_color             :integer          default(0)
#  headline               :string(255)      default("")
#  about_me               :text             default("")
#  looking_for            :text             default("")
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  attr_accessor :feet, :inches

  # username validations
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: 3..20,
            format: { with: WORD_CHARS }
  validates :zip_code,
            presence: true,
            length: { is: 5 },
            format: { with: INTEGERS }
  validate :zip_code_has_coords
  validate :over_18
  validates :headline, length: 0..50

  # likes me
  has_many :liked_by, class_name: 'Like', as: :likeable, dependent: :destroy
  has_many :likes_me, through: :liked_by, source: :user

  # I like
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :likeable,
                         source_type: 'User'

  # blocked users
  has_many :blocked_users, dependent: :destroy
  has_many :blocked, through: :blocked_users

  # blocking users
  has_many :blocking_users, class_name: 'BlockedUser',
                            foreign_key: :blocked_id, dependent: :destroy
  has_many :blocked_by, through: :blocking_users, source: :user

  # messages
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :recipients, through: :sent_messages
  has_many :received_messages, class_name: 'Message',
                               foreign_key: :recipient_id
  has_many :senders, through: :received_messages

  # pics
  has_many :pics

  after_find :height_to_feet_and_inches
  before_save :set_coordinates
  before_save :feet_and_inches_to_height
  before_destroy :remember_id
  after_destroy :remove_pics_and_directories

  def get_info(type)
    info_string = "#{ type }_info"
    send(info_string.to_sym) || info_string.camelize.constantize.new
  end

  def pool
    User.where.not(id: blocked + blocked_by << id)
  end

  def default_pic(type = false)
    args = [:image_url]
    args << type if type
    pics.first.try(*args) || 'default_person.jpeg'
  end

  def conversation_headers
    new_messages = {}
    last_messages = {}
    senders = received_messages.includes(:sender)
      .where(removed_by_recipient: false).map do |message|
        new_messages[message.sender_id] = true unless message.read
        previous_message = last_messages[message.sender_id]
        if previous_message.nil? || message.created_at > previous_message.created_at
          last_messages[message.sender_id] = message
        end
        message.sender || DeletedUser.new(message.sender_id)
      end
    recipients = sent_messages.includes(:recipient)
      .where(removed_by_sender: false).map do |message|
        previous_message = last_messages[message.recipient_id]
        if previous_message.nil? || message.created_at > previous_message.created_at
          last_messages[message.recipient_id] = message
        end
        message.recipient || DeletedUser.new(message.recipient_id)
      end
    people = (senders + recipients).try(:uniq) || []
    people.map do |person|
      {
        with: person,
        new_messages: new_messages.fetch(person.id, false),
        last_message: last_messages.fetch(person.id)
      }
    end
  end

  def unread_message_count
    received_messages.where(read: false, removed_by_recipient: false).count
  end

  def conversation(contact)
    set = [contact.id, self.id]
    Message.where(sender_id: set, recipient_id: set).order('created_at ASC')
  end

  def new_blockers_count
    blocking_users.where(new: true).count
  end

  def new_likers_count
    liked_by.where(new: true).count
  end

  def region
    zip_code.nil? ? '' : zip_code.to_region
  end

  def age
    years_old = Date.today.year - birthday.year
    years_old -= 1 if Date.today < birthday.to_date + years_old.years
    years_old
  end

  private

  def zip_code_has_coords
    if zip_code.to_latlon.nil?
      errors.add(:zip_code, 'not found')
    end
  rescue
    errors.add(:zip_code, 'invalid')
  end

  def over_18
    errors.add(:birthday, 'must be over 18') if age < 18
  end

  def set_coordinates
    self.latitude = self.zip_code.to_lat.to_f
    self.longitude = self.zip_code.to_lon.to_f
  end

  def pluralize(number, word)
    "#{ number.to_s } #{ word }" + (number > 1 ? 's' : '')
  end

  def remember_id
    @id = id
  end

  def remove_pics_and_directories
    pics.where(user_id: @id).destroy_all
    begin
      FileUtils.remove_dir("#{Rails.root}/public/uploads/pic/#{@id}")
    rescue => e
      puts e.message
    end
  end

  def height_to_feet_and_inches
    self.feet = get_feet
    self.inches = get_inches
  end

  def feet_and_inches_to_height
    self.height = begin
      feet.to_i * 12 + inches.to_i
    rescue
      0
    end
  end

  def get_feet
    height / 12
  end

  def get_inches
    height % 12
  end

end
