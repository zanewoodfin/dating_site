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
  belongs_to :user

  validates_presence_of :image
end
