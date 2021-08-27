class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  before_action :load_api_service, only: [:create]

  # Authentication page for user
  def new
  end

  # Authenticate user based on email and password
  def create
    result = @api_service.sign_in(params.slice(:email, :password).as_json)
    if result&.dig("user", "auth_token").present?
      cookies[:auth_token] = result&.dig("user", "auth_token")
      redirect_to edit_user_path(id: 1), notice: "Signed in successfully"
    else
      flash.now[:alert] = result&.dig("error", "message")
      render :new
    end
  end

  private

  # Private method to load API service
  def load_api_service
    @api_service = ApiService.new
  end
end
