# == Schema Information
#
# Table name: social_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  religion   :integer          default(0)
#  smokes     :integer          default(0)
#  drinks     :integer          default(0)
#  drugs      :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class SocialInfo < ActiveRecord::Base
  DRINKS = [
    '-',
    'Never',
    'Rarely',
    'Socially',
    'Often',
    'Every day'].freeze
  DRUGS = [
    '-',
    'Never',
    'Rarely',
    'Socially',
    'Often',
    'Every day'].freeze
  RELIGION = [
    '-',
    'Agnostic',
    'Atheist',
    'Baptist',
    'Buddhist',
    'Catholic',
    'Christian',
    'Lutheran',
    'Methodist',
    'Muslim',
    'Presbyterian'].freeze
  SMOKES = [
    '-',
    'Never',
    'Very Rarely',
    'Sometimes',
    'Often',
    'Every day'].freeze

  belongs_to :user

  def display_attributes
    [:religion, :drugs, :smokes, :drinks]
  end

  def to_s(type = false)
    case type
    when false then ''
    else  SocialInfo.const_get(type.upcase)[public_send(type)]
    end
  end

end
