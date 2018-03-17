class UsersController < ApplicationController
	before_action :set_user, only: [:update, :edit, :tweets, :followings, :followers, :likes]

	def index
	@users = User.all
	end

	def edit
	end

	def learning
	end

	def teaching
	end

	private
	def user_params
	params.require(:user).permit(:name, :introduction, :avatar)
	end

	def set_user
	@user = User.find(params[:id])
	end

end
