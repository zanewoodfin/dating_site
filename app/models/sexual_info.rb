# == Schema Information
#
# Table name: sexual_infos
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  sexual_experience    :integer          default(0)
#  created_at           :datetime
#  updated_at           :datetime
#  gender               :integer          default(0)
#  perceived_gender     :integer          default(0)
#  romantic_orientation :integer          default(0)
#  sexual_orientation   :integer          default(0)
#

class SexualInfo < ActiveRecord::Base
  SEXUAL_EXPERIENCE = [
    '-',
    'Virgin',
    '1-5 Partners',
    '6-10 Partners',
    '11-20 Partners',
    '21+ Partners'].freeze
  GENDER = [
    '-',
    'Female',
    'Male',
    'Hormone Therapy (F->M)',
    'Hormone Therapy (M->F)',
    'Reassigned(F->M)',
    'Reassigned(M->F)',
    'Androgynous'
  ].freeze
  PERCEIVED_GENDER = [
    '-',
    'Female',
    'Male',
    'Neither',
    'Fluid',
    'Androgynous'
  ].freeze
  ROMANTIC_ORIENTATION = [
    '-',
    'Heteroromantic',
    'Homoromantic',
    'Biromantic',
    'Panromantic',
    'Aromantic'
  ].freeze
  SEXUAL_ORIENTATION = [
    '-',
    'Asexual',
    'Gray-A',
    'Demisexual',
    'Sexual'
  ].freeze

  belongs_to :user

  def self.display_attributes
    [:gender, :perceived_gender, :romantic_orientation, :sexual_orientation, :sexual_experience]
  end

  def to_s(type = false)
    case type
    when false then ''
    else  SexualInfo.const_get(type.upcase)[public_send(type)]
    end
  end

end
