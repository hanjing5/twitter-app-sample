class UsersController < ApplicationController
  def show
	@user = User.find(params[:id])
	@title = @user.name
  end

  def make
    @user = 'make page'
  end

  def new
	@user = User.new
	@title = "Sign up"
  end

  def create
	@user = User.new(params[:user])
	if @user.save
		# sign in the user after signing up
		sign_in user
		# the message box
		flash[:success] = "Welcome to the Sample App!"
		# redirect to user page
		redirect_to @user
	else
		@title = "Sign up"
		render 'new'
	end
  end
end
