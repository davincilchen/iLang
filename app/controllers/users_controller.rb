class UsersController < ApplicationController
	before_action :set_user, only: [:update, :edit, :learning, :teaching]

	def index
		@users = User.all
	end

	def edit
		@current_learnings = current_user.learnings.select(:language_id).pluck(:language_id)
		@current_teachings = current_user.teachings.select(:language_id).pluck(:language_id)
	end

	def update
	end

	def learning
		params[:languages].each do |l|
			puts "adding language #{l} for user #{current_user}"
			@learning = current_user.learnings.new(language_id: l)
			@learning.save
		end
		
		redirect_back fallback_location: root_path
	end

	def teaching
		params[:languages].each do |l|
			puts "adding language #{l} for user #{current_user}"
			@teaching = current_user.teachings.new(language_id: l)
			@teaching.save
		end
		redirect_back fallback_location: root_path
	end

	private
	def user_params
	params.require(:user).permit(:name, :introduction, :avatar)
	end

	def set_user
	@user = User.find(params[:id])
	end

end
