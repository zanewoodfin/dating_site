class RegistrationsController < Devise::RegistrationsController
  before_action :set_birthday, only: :create

  private

  def set_birthday
    birthday = params[:birthday]
    params[:user][:birthday] = DateTime.new(birthday[:year].to_i, birthday[:month].to_i, birthday[:day].to_i)
  rescue
    params.delete(:birthday)
    redirect_to new_user_registration_path
  end
end
