class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  # 例外処理
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from Exception, with: :render_500

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render file: Rails.root.join('public', '404.html.erb'), layout: false, status: :not_found
  end

  def render_500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e
    render file: Rails.root.join('public', '500.html.erb'), layout: false, status: :internal_server_error
  end

  private

  def not_authenticated
    redirect_to root_path
    flash[:danger] = 'ログイン後にご覧いただけます'
  end
end
