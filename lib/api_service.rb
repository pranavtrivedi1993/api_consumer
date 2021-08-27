class ApiService

  # Initialize API service with host
  def initialize
    @api_host = Rails.application.secrets.api_host.to_s || ENV["API_HOST"].to_s
  end

  # Call sign up API
  def sign_up(user = {})
    if @api_host.present? && user.present?
      begin
        request_url = @api_host + "/api/v1/sign_up"
        payload = Hash.new
        payload[:user] = user
        request_headers = { "Content-Type" => "application/json" }
        response = RestClient.post(request_url, payload.to_json, request_headers)
        result = JSON.parse(response.body)
        Rails.logger.info "===== sign up result ===== #{result} ====="
        result
      rescue RestClient::ExceptionWithResponse => e
        error = JSON.parse(e.response)
        Rails.logger.warn "===== sign up errors ===== #{error} ====="
        error
      end
    end
  end

  # Call sign in API
  def sign_in(user = {})
    if @api_host.present? && user.present?
      begin
        request_url = @api_host + "/api/v1/authenticate"
        payload = user
        request_headers = { "Content-Type" => "application/json" }
        response = RestClient.post(request_url, payload.to_json, request_headers)
        result = JSON.parse(response.body)
        Rails.logger.info "===== sign in result ===== #{result} ====="
        result
      rescue RestClient::ExceptionWithResponse => e
        error = JSON.parse(e.response)
        Rails.logger.warn "===== sign in errors ===== #{error} ====="
        error
      end
    end
  end

  # Call update user API
  def update_user(auth_token, user = {})
    if @api_host.present? && user.present?
      begin
        request_url = @api_host + "/api/v1/profile"
        payload = Hash.new
        payload[:user] = user
        request_headers = { "Content-Type" => "application/json", "Authorization" => "Bearer " + auth_token.to_s }
        response = RestClient.post(request_url, payload.to_json, request_headers)
        result = JSON.parse(response.body)
        Rails.logger.info "===== update user result ===== #{result} ====="
        result
      rescue RestClient::ExceptionWithResponse => e
        error = JSON.parse(e.response)
        Rails.logger.warn "===== update user errors ===== #{error} ====="
        error
      end
    end
  end

  # Call get user API
  def get_user(auth_token)
    if @api_host.present?
      begin
        request_url = @api_host + "/api/v1/user_details"
        request_headers = { "Content-Type" => "application/json", "Authorization" => "Bearer " + auth_token.to_s }
        response = RestClient.get(request_url, request_headers)
        result = JSON.parse(response.body)
        Rails.logger.info "===== get user result ===== #{result} ====="
        result
      rescue RestClient::ExceptionWithResponse => e
        error = JSON.parse(e.response)
        Rails.logger.warn "===== get user errors ===== #{error} ====="
        error
      end
    end
  end
end
