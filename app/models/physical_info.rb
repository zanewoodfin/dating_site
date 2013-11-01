# == Schema Information
#
# Table name: physical_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ethnicity  :integer          default(0)
#  height     :integer          default(0)
#  body_type  :integer          default(0)
#  weight     :integer          default(0)
#  eye_color  :integer          default(0)
#  hair_color :integer          default(0)
#  body_hair  :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class PhysicalInfo < ActiveRecord::Base
  attr_accessor :feet, :inches

  BODY_TYPE = [
    '-',
    'Thin',
    'Average',
    'A few extra pounds',
    'More to Love',
    'Athletic',
    'Muscular',
    'Very Muscular'].freeze
  BODY_HAIR = [
    '-',
    'Naturally hairless',
    'Neatly shaven/waxed',
    'Light',
    'Moderate',
    'Gorilla'].freeze
  ETHNICITY = [
    '-',
    'Asian',
    'Black',
    'Caucasian',
    'Hispanic',
    'Indian',
    'Mixed',
    'Native American',
    'Other'].freeze
  EYE_COLOR = [
    '-',
    'Blue',
    'Brown',
    'Green',
    'Hazel',
    'Other'].freeze
  FEET = (0..8).to_a.freeze
  HAIR_COLOR = [
    '-',
    'Bald',
    'Blonde',
    'Brunette',
    'Hairless',
    'Red',
    'White'].freeze
  INCHES = (0..11).to_a.freeze

  belongs_to :user

  after_find :set_feet_inches
  before_save :convert_to_height

  def display_attributes
    [:ethnicity, :body_type, :eye_color, :hair_color, :body_hair, :height, :weight]
  end

  def to_s(type = false)
    case type
    when :weight then "#{weight} lbs."
    when :height then "#{get_feet}' #{get_inches}\""
    when false then ''
    else  PhysicalInfo.const_get(type.upcase)[public_send(type)]
    end
  end

private

  def set_feet_inches
    self.feet = get_feet
    self.inches = get_inches
  end

  def convert_to_height
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

