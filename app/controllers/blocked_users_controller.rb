class BlockedUsersController < ApplicationController
  def index
    @blocked = current_user.blocked
    @blocked_by = current_user.blocked_by
  end
end
