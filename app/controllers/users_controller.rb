class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [:index]
  before_action :correct_user?, only: [:edit, :update, :destroy]

  def destroy
    @user.destroy
    redirect_to root_path
  end

  def edit
    redirect_to user_path(@user)
  end

  def index
    @users = current_user.unblocked
  end

  def show
    redirect_to(root_path) if @user.blocked.include?(current_user)
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user?
    redirect_to(root_path) unless current_user?(@user)
  end

end

