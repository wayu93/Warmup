class UsersController < ApplicationController
  include ActionView::Helpers::TextHelper

  def new
    @user = User.new
    flash.now[:welcome] = "Please enter your credentials below"
  end

  # shows welcome message after each login
  def show
    @user = current_user
    if @user
      past = pluralize @user.count, "time"
      flash.now[:login] = "Welcome #{@user.username}. You have logged in #{past}."
    end
  end

  def create
    @user =  User.new(params[:user])
    input, type = params[:user], params[:commit]

    # checks if user clicked 'Add User' or 'Login' then
    # validates username and password using methods located
    # in app/helpers/users_helper.rb
    if type == "Add User"
      error = valid_signup(input[:username], input[:password])
    else
      error = valid_login(input[:username], input[:password])
      @user = User.find_by_username(input[:username]) if !error
    end

    # sign in user if no error found or else display
    # error message
    if !error and @user.save
      sign_in @user
      redirect_to @user
    else
      flash.now[:error] = error
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
