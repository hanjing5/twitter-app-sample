class UsersController < ApplicationController
  def show
	@user = User.find(params[:id])
  end

  def make
    @user = 'make page'
  end
  def new
	@title = "Sign up"
  end

end
