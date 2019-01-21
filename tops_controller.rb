class TopsController < ApplicationController
  skip_before_action :require_login, only: [:top]
  layout 'top'

  def top; end
end
