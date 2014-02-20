module UsersHelper

  # records current_user's remember_token to keep track of session
  # and sets current_user to user
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  # validates that the password and username match
  def valid_login(name, pwd)
    bad_credentials = "Invalid username and password combination. Please try again."
    user1 = User.find_by_username(name)
    valid = (user1.password == pwd) if user1
    msg = nil
    msg = bad_credentials if !valid
  end

  # validates that the password and username are valid for new user
  def valid_signup(name, pwd)
    bad_username = "The user name should be non-empty and at most 128 characters long. Please try again."
    bad_password =  "The password should be at most 128 characters long. Please try again."
    user_exists = "This user name already exists. Please try again."
    msg = nil
    if name.nil? or name.length == 0 or name.length > 128
      msg = bad_username
    elsif User.find_by_username(name)
      msg = user_exists
    elsif pwd.length > 128
      msg = bad_password
    end
  end

  def signed_in?
    !current_user.nil?
  end

  # sets current_user to nil and ends session
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  # if current user is nil, then search in database
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

end
