# == Schema Information
#
# Table name: social_infos
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  religion              :integer          default(0)
#  smokes                :integer          default(0)
#  drinks                :integer          default(0)
#  drugs                 :integer          default(0)
#  created_at            :datetime
#  updated_at            :datetime
#  political_orientation :integer          default(0)
#  diet                  :integer          default(0)
#

class SocialInfo < ActiveRecord::Base
  DIET = %w(
    -
  ).freeze
  DRINKS = %w(
    -
    Never
    Rarely
    Socially
    Often
    Every\ day).freeze
  DRUGS = %w(
    -
    Never
    Rarely
    Socially
    Often
    Every\ day).freeze
  POLITICAL_ORIENTATION = %w(
    -
    Socialist
    Liberal
    Moderate
    Republican
    Libertarian
  ).freeze
  RELIGION = %w(
    -
    Agnostic
    Atheist
    Baptist
    Buddhist
    Catholic
    Christian
    Lutheran
    Methodist
    Muslim
    Presbyterian).freeze
  SMOKES = %w(
    -
    Never
    Very\ rarely
    Sometimes
    Often
    Every\ day).freeze

  belongs_to :user

  def self.display_attributes
    [:religion, :political_orientation, :diet , :drugs, :smokes, :drinks]
  end

  def to_s(type = false)
    case type
    when false then ''
    else  SocialInfo.const_get(type.upcase)[public_send(type)]
    end
  end
end
