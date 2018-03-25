class UsersController < ApplicationController

	before_action :set_user, only: [:update, :edit, :learning, :teaching, :show]
  
	def index
		@users = User.all
	end

  def show
    @teaching_languages = @user.teaching_languages.pluck(:name).to_sentence
    @learning_languages = @user.learning_languages.pluck(:name).to_sentence
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

    Learning.where(user: current_user).destroy_all
    params[:learn_languages].each do |l|
      puts "adding language #{l} for user #{current_user}"
      @learning = current_user.learnings.new(language_id: l)
      @learning.save
    end

    Teaching.where(user: current_user).destroy_all
    params[:teach_languages].each do |l|
      puts "adding language #{l} for user #{current_user}"
      @teaching = current_user.teachings.new(language_id: l)
      @teaching.save
    end
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


	private


	def set_user
		@user = User.find(params[:id])
	end


  def user_params
    params.require(:user).permit(:username, :description, :avatar)
  end


end
