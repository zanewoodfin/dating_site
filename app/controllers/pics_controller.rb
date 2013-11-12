class PicsController < ApplicationController
  before_action :set_pic, only: [:show, :update, :destroy]
  before_action :correct_user?, only: [:update, :destroy]

  def create
    @pic = current_user.pics.build(pic_params)
    @pic.save
    redirect_to :back
  end

  def destroy
    @pic.destroy
    respond_to do |format|
      format.html do
        redirect_to :back
      end
    end
  end

  def index
    @user = User.find(params[:user_id])
    check_if_blocked
    @thumbnails = @user.pics
    @pic = Pic.new
  end

  def show
    @user = @pic.user
    check_if_blocked
  end

  def update
    respond_to do |format|
      format.js do
        @valid = @pic.update(pic_params)
      end
    end
  end

private

  def correct_user?
    redirect_to(root_path) unless current_user == @pic.user
  end

  def set_pic
    @pic = Pic.find(params[:id])
  end

  def pic_params
    params.require(:pic).permit(:image, :caption)
  end

end
