class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all#current_user.unblocked
  end

end

