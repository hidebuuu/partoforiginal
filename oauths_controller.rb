class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      flash[:success] = "#{provider.titleize}からログインしました!"
      redirect_to reviews_path
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        flash[:success] = "#{provider.titleize}からログインしました!"
        redirect_to root_path
      rescue OAuth2Error
        flash[:danger] = "#{provider.titleize}のログインに失敗しました"
        redirect_to root_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
