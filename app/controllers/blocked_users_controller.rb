class BlockedUsersController < ApplicationController

  def index
    @blocked = current_user.blocked_users
    @blocked_by = current_user.blocking_users
    current_user.blocking_users.update_all(new: false)
  end

  def create
    @blocked_user = current_user.blocked_users.build(blocked_id: params[:blocked_id])
    @valid = @blocked_user.save
    if @valid
      current_user.liked_by.where(user_id: params[:blocked_id]).destroy_all
    end
    redirect_to users_path
  end

  def destroy
    @blocked_user = BlockedUser.find(params[:id])
    if @blocked_user.user == current_user
      @valid = @blocked_user.destroy
    end
    redirect_to users_path
  end

end
