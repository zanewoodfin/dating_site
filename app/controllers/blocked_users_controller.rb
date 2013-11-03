class BlockedUsersController < ApplicationController

  def index
    @blocked = current_user.blocked_users
    @blocked_by = current_user.blocking_users
  end

  def create
    @blocked_user = current_user.blocked_users.build(blocked_id: params[:blocked_id])
    @valid = @blocked_user.save
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
