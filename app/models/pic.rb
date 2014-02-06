# == Schema Information
#
# Table name: pics
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  caption    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Pic < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  PIC_LIMIT = 6

  belongs_to :user

  validates_presence_of :image
  validate :within_user_pic_limit

  before_destroy :remember_id
  after_destroy :remove_id_directory

  private

  def remember_id
    @id = id
    @user = user
  end

  def remove_id_directory
    begin
      FileUtils.remove_dir("#{Rails.root}/public/uploads/pic/#{@user.id}/#{@id}")
    rescue => e
      puts e.message
    end
  end

  def within_user_pic_limit
    if user.pics.count >= PIC_LIMIT
      errors.add(:base, 'already have the max number of pics')
    end
  end
end
