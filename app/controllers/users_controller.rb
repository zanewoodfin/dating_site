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
    @section_form = case @section
    when 'physical' then
      current_user.physical_info || PhysicalInfo.new
    when 'social' then
      current_user.social_info || SocialInfo.new
    when 'sexual' then
      current_user.sexual_info || SexualInfo.new
    when 'essay' then
      current_user.essay_info || EssayInfo.new
    end
  end

  def index
    @users = current_user.pool
  end

  def show
    check_if_blocked
    @user_pic = @user.pics.first
    @pic = Pic.new
  end

  def update
    section = false
    if params[:physical_info]
      @physical_info = PhysicalInfo.new(physical_params)
      if @physical_info.save
        current_user.physical_info = @physical_info
        current_user.save
      else
        section = 'physical'
      end
    elsif params[:social_info]
      @social_info = SocialInfo.new(social_params)
      if @social_info.save
        current_user.social_info = @social_info
        current_user.save
      else
        section = 'social'
      end
    elsif params[:sexual_info]
        @sexual_info = SexualInfo.new(sexual_params)
      if @sexual_info.save
        current_user.sexual_info = @sexual_info
        current_user.save
      else
        section = 'sexual'
      end
    elsif params[:essay_info]
       @essay_info = EssayInfo.new(essay_params)
      if @essay_info.save
        current_user.essay_info = @essay_info
        current_user.save
      else
        section = 'essay'
      end
    end

    if section
      redirect_to :back, section: section
    else
      redirect_to current_user
    end
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user?
    redirect_to(root_path) unless current_user == @user
  end

  def physical_params
    params.require(:physical_info).permit(:ethnicity, :body_type, :hair_color, :body_hair, :eye_color, :weight, :feet, :inches, :user_id)
  end

  def social_params
    params.require(:social_info).permit(:religion, :political_orientation, :diet , :drugs, :smokes, :drinks, :user_id)
  end

  def sexual_params
    params.require(:sexual_info).permit(:gender, :perceived_gender, :romantic_orientation, :sexual_orientation, :sexual_experience, :user_id)
  end

  def essay_params
    params.require(:essay_info).permit(:headline, :about_me)
  end

end

