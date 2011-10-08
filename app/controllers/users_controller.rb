class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy


  def make
    @user = 'make page'
  end

  def new
	#if signed_in?
	#	redirect_to(root_path)
	#end
	@user = User.new
	@title = "Sign up"
  end

  def create
	@user = User.new(params[:user])
	#if signed_in?
	#	redirect_to(root_path)
	#end
	if @user.save
		# sign in the user after signing up
		sign_in @user
		# the message box
		flash[:success] = "Welcome to the Sample App!"
		# redirect to user page
		redirect_to @user
	else
		@title = "Sign up"
		render 'new'
	end
  end

  def edit
	#@user = User.find(params[:id])
	@title = "Edit user"
  end

  def update
	@user = User.find(params[:id])
	if @user.update_attributes(params[:user])
		flash[:success] = "Profile updated."
		redirect_to @user
	else
		@title = "Edit user"
		render 'edit'
	end
  end

  def index
	@title = "All users"
	@users = User.paginate(:page => params[:page])
  end

  def show
	@user = User.find(params[:id])
	@title = @user.name
  end

  def destroy
	if current_user.id.to_s == params[:id]
		flash[:error] = "You can't delete yourself."
		redirect_to users_path
	else
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_path
	end
  end

  private 

	def authenticate
		deny_access unless signed_in?
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end

	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
end
