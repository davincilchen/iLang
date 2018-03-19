class UsersController < ApplicationController
	before_action :set_user, only: [:update, :edit, :learning, :teaching]

	def index
		@users = User.all
	end

  def show
    @user = User.find(params[:id])
  end

  def edit
    unless @user == current_user
      redirect_to user_path(@user)
    end
    @current_learnings = current_user.learnings.select(:language_id).pluck(:language_id)
    @current_teachings = current_user.teachings.select(:language_id).pluck(:language_id)

  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end


  def search
    if params["option"] == "Teach"
      # select all language
      if params[:language][:id] == ""
        @users = User.joins(:teaching_languages).group('users.id').having('count(user_id) > 0').order("random()")
      # select certain language
      else
        @users = User.joins(:teaching_languages).where("name = ?", params[:language][:id]).all.order("random()")
      end

    elsif params["option"] == "Learn"
      
      if params[:language][:id] == ""
        @users = User.joins(:learning_languages).group('users.id').having('count(user_id) > 0').order("random()")
      else
        @users = User.joins(:learning_languages).where("name = ?", params[:language][:id]).all.order("random()")
      end
    end     
  end

	def learning
		Learning.where(user: current_user).destroy_all
		params[:languages].each do |l|
			puts "adding language #{l} for user #{current_user}"
			@learning = current_user.learnings.new(language_id: l)
			@learning.save
		end
		
		redirect_back fallback_location: root_path
	end

	def teaching
		Teaching.where(user: current_user).destroy_all
		params[:languages].each do |l|
			puts "adding language #{l} for user #{current_user}"
			@teaching = current_user.teachings.new(language_id: l)
			@teaching.save
		end
		redirect_back fallback_location: root_path
	end


	private


	def set_user
		@user = User.find(params[:id])
	end


  def user_params
    params.require(:user).permit(:username, :description, :avatar)
  end

end
