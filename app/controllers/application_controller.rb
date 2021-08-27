class ApplicationController < ActionController::Base
  before_action :authenticate_request
  attr_reader :current_auth_token

  private

  # Private method to authenticate request
  def authenticate_request
    if cookies[:auth_token].present?
      @current_auth_token = cookies[:auth_token]
    else
      redirect_to new_authentication_path, alert: "You need to sign in before continuing"
    end
  end
end
