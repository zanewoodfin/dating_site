# Handles which users are liked by whom
class LikesController < ApplicationController
  def destroy # format.js
    @likeable = current_user.likes
      .where(likeable_id: params[:id], likeable_type: params[:type])
    @likeable_object = params[:type].constantize.find(params[:id])
    @likeable.destroy_all
    render 'users/create_destroy'
  end

  def index
    @likes_me = current_user.likes_me
    @liked_users = current_user.liked_users
    current_user.liked_by.update_all(new: false)
  end

  def create # format.js
    @likeable = current_user.likes
      .build(likeable_id: params[:format], likeable_type: params[:type])
    @likeable_object = params[:type].constantize.find(params[:format])
    @likeable.save
    render 'users/create_destroy'
  end
end
