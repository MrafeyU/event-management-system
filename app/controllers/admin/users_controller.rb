class Admin::UsersController < ApplicationController
  def index
    @users = User.all.order(created_at: :desc).includes(:bookings)
  end


  def show
    @user = User.find(params[:id])
    @bookings = @user.bookings.includes(:event) 
  end



  def new
    @user = User.new
  end



  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: "User created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end




  def edit
    @user = User.find(params[:id])
  end



  def update  
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def suspend
    @user = User.find(params[:id])
    @user.update(suspended: true)
    redirect_to admin_user_path(@user), notice: "User suspended successfully."
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully."  
  end

  private 
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end 
end
