# == Schema Information
#
# Table name: sexual_infos
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  sexual_experience :integer          default(0)
#  created_at        :datetime
#  updated_at        :datetime
#

class SexualInfo < ActiveRecord::Base
  SEXUAL_EXPERIENCE = [
    '-',
    'Virgin',
    '1-5 Partners',
    '6-10 Partners',
    '11-20 Partners',
    '21+ Partners'].freeze

  belongs_to :user

  def display_attributes
    [:sexual_experience]
  end

  def to_s(type = false)
    case type
    when false then ''
    else  SexualInfo.const_get(type.upcase)[public_send(type)]
    end
  end

end
