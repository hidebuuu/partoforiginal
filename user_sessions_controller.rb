class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def destroy
    logout
    redirect_to root_path
    flash[:success] = 'ログアウトしました'
  end
end
