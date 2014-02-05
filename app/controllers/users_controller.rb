# Controls all user actions including update of all has_one associated objects.
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:destroy, :edit, :show, :update]
  before_action :correct_user?, only: [:edit, :update, :destroy]

  def destroy
    @user.destroy
    redirect_to root_path
  end

  def edit
    @section = params[:section]
    @section_form = current_user.get_info(@section)
  end

  def index
    pool = current_user.pool
    @search_form = SearchForm.new(params[:search_form] || {})
    @users = search(pool).includes(:essay_info).paginate(page: params[:page])
  end

  def show
    check_if_blocked
    @user_pic = @user.default_pic
    @pic = Pic.new
  end

  def update
    @section = false
    %w(physical social sexual essay).each do |info_type|
      update_info(info_type) if params["#{info_type}_info".to_sym]
    end
    if @section
      redirect_to :back, section: @section
    else
      redirect_to current_user
    end
  end

  private

  def search(pool)
    max_distance = @search_form.max_distance
    if max_distance.blank? || max_distance == 'any'
      pool
    else
      pool.within(max_distance, origin: current_user)
    end
  end

  def update_info(info_type)
    info_sym = "#{ info_type }_info=".to_sym
    info_params = "#{ info_type }_params".to_sym
    info_class = "#{ info_type }_info".camelize.constantize
    info_object = info_class.new(send(info_params))
    if info_object.valid?
      current_user.public_send(info_sym, info_object)
    else
      @section = info_string.gsub(/_info/, '')
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user?
    redirect_to(root_path) unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:username, :zip_code)
  end

  def physical_params
    params.require(:physical_info)
      .permit(:ethnicity, :body_type, :hair_color, :body_hair, :eye_color,
              :weight, :feet, :inches, :user_id)
  end

  def social_params
    params.require(:social_info)
      .permit(:religion, :political_orientation, :diet , :drugs, :smokes,
              :drinks, :user_id)
  end

  def sexual_params
    params.require(:sexual_info)
      .permit(:gender, :perceived_gender, :romantic_orientation,
              :sexual_orientation, :sexual_experience, :user_id)
  end

  def essay_params
    params.require(:essay_info).permit(:headline, :about_me, :looking_for)
  end
end
