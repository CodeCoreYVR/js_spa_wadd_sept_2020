class SessionsController < ApplicationController
  def new 
  end

  def create
    # Since we're not initializing any user instance in the session/new
    # page, we are retrieving the data from the form from the params 
    # directly and not in a nested hash named after a model.
    user = User.find_by_email params[:email]

    # "authenticate" will take the plain text password from the form and
    # bcrypt will hash it and compare it to the value in "password_digest"
    if user&.authenticate(params[:password])
    # Equivalent to user && user.authenticate(params[:password])
      # "session" is an object that uses cookies to store encrypted data.
      # To sign in a user we'll set the "user_id" in the session so we
      # can retrieve it later.
      session[:user_id] = user.id
      flash[:primary] = "Welcome, #{user.full_name}"
      redirect_to root_path
    else 
      flash[:info] = "Wrong email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:primary] = "Signed Out"
    redirect_to root_path
  end
end
