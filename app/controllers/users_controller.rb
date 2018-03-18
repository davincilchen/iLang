class UsersController < ApplicationController
	before_action :set_user, only: [:update, :edit, :learning, :teaching]

	def index
		@users = User.all
	end

	def edit

	end

	def update
	end

	def learning
		@learning = current_user.learnings.build(language_id: params[:anguages])
		@learning.save

	end

	def teaching
		@teaching = current_user.teachings.build(language_id: params[:languages])
		@teaching.save
	end

	private
	def user_params
	params.require(:user).permit(:name, :introduction, :avatar)
	end

	def set_user
	@user = User.find(params[:id])
	end

end
