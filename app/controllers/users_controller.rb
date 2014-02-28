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
    @users = search(pool).paginate(page: params[:page])
  end

  def show
    check_if_blocked
    @user_pic = @user.default_pic
    @pic = Pic.new
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
end
