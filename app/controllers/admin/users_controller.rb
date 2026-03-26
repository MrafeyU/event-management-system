class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  
  def index
    @users = policy_scope([:admin, User]).all.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: "User was successfully created." 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
  end

  def update
    # authorize [:admin, @user]
    if user_params[:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User was successfully updated.", status: :see_other 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # authorize [:admin, @user]
    @user.destroy!
      redirect_to admin_users_path, notice: "User was successfully destroyed.", status: :see_other 
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
        
  def user_params
    params.require(:user).permit(:type, :name, :email, :password, :password_confirmation)
  end
end
