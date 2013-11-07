class UsersController < ApplicationController
  before_filter :require_current_user!, :only => [:edit, :update, :delete]
  before_filter :require_logged_out!, :only => [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      login_user!(@user)
      redirect_to @user
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.is_password?(params[:password])
      if @user.update_attributes(params[:user])
        login_user!(@user)
        redirect_to @user
      else
        flash.now[:errors] = @user.errors.full_messages
        render :edit
      end
    else
      flash.now[:errors] = ["Incorrect Password"]
      render :edit
    end
  end
end
