# Allows users to block/unblock fellow users.
# Blocked users cannot like, view, or message their blockers.
class BlockedUsersController < ApplicationController
  def index
    @blocked = current_user.blocked_users
    @blocked_by = current_user.blocking_users
    current_user.blocking_users.update_all(new: false)
  end

  def create
    blocked_id = params[:blocked_id]
    @blocked_user = current_user.blocked_users.create(blocked_id: blocked_id)
    if @blocked_user.persisted?
      current_user.liked_by.where(user_id: blocked_id).destroy_all
    end
    redirect_to users_path
  end

  def destroy
    @blocked_user = BlockedUser.find(params[:id])
    @blocked_user.destroy if @blocked_user.user == current_user
    redirect_to users_path
  end
end
