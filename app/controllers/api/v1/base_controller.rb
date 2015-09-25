class Api::V1::BaseController < ActionController::Base

  before_action :restrict_access, except: [:ping]
  respond_to :json

  def ping
    render json: {pong: true}
  end

  private

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(api_key: token).first
        not @user.nil?
      end
    end


end