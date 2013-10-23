class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # username validations
  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: 3..20

  # blocked users
  has_many :blocked_users, dependent: :destroy
  has_many :blocked, through: :blocked_users

  # blocking users
  has_many :blocking_users, class_name: 'BlockedUser',  foreign_key: :blocked_id, dependent: :destroy
  has_many :blocked_by, through: :blocking_users, source: :user

  def unblocked
    User.where.not(id: blocked + blocked_by << id)
  end

end
