class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:new, :create]
  before_action :load_api_service, only: [:create, :edit, :update]

  # Registration page for user
  def new
    @user = User.new
  end

  # Create new user
  def create
    @user = User.new(sign_up_params)
    result = @api_service.sign_up(@user.as_json)
    if result&.dig("user").present?
      redirect_to new_authentication_path, notice: "You are registered successfully"
    else
      flash.now[:alert] = result&.dig("error")
      render :new
    end
  end

  # Edit user profile
  def edit
    @user = User.new
    result = @api_service.get_user(current_auth_token)
    if result&.dig("user").present?
      @user.first_name = result&.dig("user", "first_name")
      @user.last_name = result&.dig("user", "last_name")
      @user.email = result&.dig("user", "email")
    end
  end

  # Update user based on provided parameters
  def update
    @user = User.new(user_params)
    result = @api_service.update_user(current_auth_token, @user.as_json)
    if result&.dig("user").present?
      redirect_to edit_user_path(id: 1), notice: "Your profile has been updated successfully"
    else
      flash.now[:alert] = result&.dig("error")
      render :edit
    end
  end

  # Sign out user
  def destroy
    cookies.delete :auth_token
    redirect_to new_authentication_path, notice: "Signed out successfully"
  end

  private

  # Strong parameters to permit for user sign up
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  # Strong parameters to permit for user update
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end

  # Private method to load API service
  def load_api_service
    @api_service = ApiService.new
  end
end
