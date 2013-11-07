class LikesController < ApplicationController
  def destroy
    @likeable = current_user.likes.where(likeable_id: params[:id], likeable_type: params[:type])
    @likeable.destroy_all
    redirect_to :back
  end

  def index
    @likes_me = current_user.likes_me
    @liked_users = current_user.liked_users
    current_user.liked_by.update_all(new: false)
  end

  def new
    @likeable = current_user.likes.build(likeable_id: params[:id], likeable_type: params[:type])
    @likeable.save
    redirect_to :back
  end

end
