class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_role, only: [:index, :destroy, :new, :create]
  before_action :select_user, only: [:edit, :update, :destroy]

  def index
    @users = User.order("name ASC")
  end

  def new
    @user = User.new
    @user.role = 'guest'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
    redirect_to root_url and return if not current_user.is_admin? and not current_user.eql?(@user)
  end

  def update
    redirect_to root_url and return if not current_user.is_admin? and not current_user.eql?(@user)
    logger.debug user_params
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    redirect_to users_path if current_user.eql?(@user)
    @user.destroy
    redirect_to users_path
  end

  private

    def check_user_role
      redirect_to root_url and return unless current_user.is_admin?
    end

    def select_user
      if params[:id]
        @user = User.find params[:id]
      else
        @user = current_user
      end
    end

    def user_params
      params.require(:user).permit(:name, :surname, :email, :role, :password, :password_confirmation).tap do |whitelisted|
        whitelisted.delete(:role) unless current_user.is_admin?
        whitelisted.delete(:password) if whitelisted[:password].blank?
        whitelisted.delete(:password_confirmation) if whitelisted[:password_confirmation].blank?
      end
    end
end