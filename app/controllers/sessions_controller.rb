class SessionsController < ApplicationController
  before_filter :require_current_user!, :only => [:destroy]
  before_filter :require_logged_out!, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(params[:user])

    if !!@user
      login_user!(@user)

      respond_to do |format|
        format.html { redirect_to @user }
        format.json { render :json => @user }
      end
    else
      @user = User.new
      flash.now[:errors] = ["Invalid username or password"]

      respond_to do |format|
        format.html { render :new }
        format.json { render :json => flash[:errors] }
      end
    end
  end

  def destroy
    logout_user!(current_user)
    redirect_to new_session_url
  end
end
