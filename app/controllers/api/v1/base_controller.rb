class Api::V1::BaseController < ActionController::Base

  before_action :restrict_access, except: [:ping]
  before_action :check_auth, only: [:create, :update, :destroy]
  respond_to :json

  def ping
    render json: {pong: true}
  end

  protected

    def current_user
      @user
    end

    def auth_error
      render json: {error: "Unauthorized", status: 401}, status: :unauthorized
    end

    def request_error
      render json: {error: "Unprocessable entity", status: 422}, status: :unprocessable_entity
    end

  private

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        @user = User.where(api_key: token).first
        not @user.nil?
      end
    end

    def check_auth
      case self.action_name
      when 'create'
        auth_error and return if current_user.is_guest?
      when 'destroy', 'update'
        klass_name = params[:type].nil? ? self.controller_name.singularize : "#{self.controller_name.singularize}/#{params[:type]}"
        klass = klass_name.classify.constantize rescue nil
        resource = klass.try(:find, params[:id]) rescue nil
        request_error and return unless resource
        auth_error and return if current_user.is_guest?
        auth_error and return if current_user.is_user? and not resource.owner.eql?(current_user)
      end
    end

end