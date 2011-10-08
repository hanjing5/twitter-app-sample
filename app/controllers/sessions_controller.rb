class SessionsController < ApplicationController
  def new
	@title = "Sign in"
  end

  def create
	user = User.authenticate(params[:session][:email],
							 params[:session][:password])
	if user.nil?
		# Create an error emssage and re-render the sign in form
		# use flash.now to avoid the flash message reappearing twice
		# since we are NOT doing redirect
		flash.now[:error] = "Invalid email/password combination."
		@title = "Sgin in"
		render 'new'
	else
		# Sign the user in and redirect to the user's show page
		sign_in user
		redirect_back_or user
	end
  end

  def destroy
	sign_out
	redirect_to root_path
  end

end
