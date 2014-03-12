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
  end

  def index
    pool = current_user.pool
    @search_form = SearchForm.new(params[:search_form] || {})
    @users = search(pool).paginate(page: params[:page])
  end

  def show
    check_if_blocked
    @user_pic = @user.default_pic
    @pic = Pic.new
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      flash[:error] = 'Invalid information.'
      redirect_to :back
    end
  end

  private

  def search(pool)
    max_distance = @search_form.max_distance
    min_birthday = DateTime.now - @search_form.max_age.to_i.years
    pool = pool.where('birthday >= ?', min_birthday)
    if @search_form.max_age.to_i < 99
      max_birthday = DateTime.now - @search_form.min_age.to_i.years
      pool = pool.where('birthday <= ?', max_birthday)
    end
    unless max_distance.blank? || max_distance == 'any'
      pool = pool.within(max_distance, origin: current_user)
    end
    pool
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user?
    redirect_to(root_path) unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:feet, :inches, :ethnicity, :body_type, :eye_color, :hair_color, :religion, :political_orientation, :smokes, :drinks, :drugs, :headline, :about_me, :looking_for)
  end
end
