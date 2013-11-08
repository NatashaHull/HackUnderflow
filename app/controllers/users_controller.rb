class UsersController < ApplicationController
  before_filter :require_current_user!, :only => [:edit, :update, :delete]
  before_filter :require_logged_out!, :only => [:new, :create]

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render :json => @user }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.set_session_token
    if @user.save
      login_user!(@user)
      respond_with_user
    else
      flash.now[:errors] = @user.errors.full_messages
      
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => flash[:errors] }
      end
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
        respond_with_user
      else
        flash.now[:errors] = @user.errors.full_messages
        respond_with_edit_error
      end
    else
      flash.now[:errors] = ["Incorrect Password"]
      respond_with_edit_error
    end
  end

    def respond_with_user
      respond_to do |format|
        format.html { redirect_to @user }
        format.json { render :json => @user }
      end
    end

    def respond_with_update_error
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => flash[:errors] }
      end
    end
end
