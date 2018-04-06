class UsersController < ApplicationController
  before_action :authenticate_user!, except: :landing
  helper_method :sort_column, :sort_direction
	before_action :set_user, only: [:update, :edit, :learning, :teaching, :show, :search_lessons]
  
  def home
  end

	def index
		@users = User.all

    @recent_lessons = Lesson.where(teacher_id: current_user).or(Lesson.where(student_id: current_user)).order(created_at: :desc).limit(10)

    @recent_lessons.each do |lesson|
      if lesson.status == true
        @lesson = lesson
      end
    end

    if current_user.teaching_languages.count == 0 && current_user.learning_languages.count == 0
      flash[:notice] = "Plase select the language that you want to teach or learn"
      redirect_to edit_user_path(current_user)
    end
	end

  def show
    @teaching_languages = @user.teaching_languages.pluck(:name).to_sentence
    @learning_languages = @user.learning_languages.pluck(:name).to_sentence
    @lessons = Lesson.where(teacher_id: params[:id]).or(Lesson.where(student_id: params[:id])).order(sort_column + " " + sort_direction)
  end

  def search_lessons
    @teaching_languages = @user.teaching_languages.pluck(:name).to_sentence
    @learning_languages = @user.learning_languages.pluck(:name).to_sentence
    @lessons = Lesson.where(teacher_id: params[:id]).or(Lesson.where(student_id: params[:id])).search(params[:search]).order(sort_column + " " + sort_direction)
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

    if params[:learn_languages] == nil && params[:teach_languages] == nil

    elsif params[:learn_languages] == nil && params[:teach_languages] != nil
      Teaching.where(user: current_user).destroy_all
      params[:teach_languages].each do |l|
        puts "adding language #{l} for user #{current_user}"
        @teaching = current_user.teachings.new(language_id: l)
        @teaching.save
      end
    elsif params[:learn_languages] != nil && params[:teach_languages] == nil
      Learning.where(user: current_user).destroy_all
      params[:learn_languages].each do |l|
        puts "adding language #{l} for user #{current_user}"
        @learning = current_user.learnings.new(language_id: l)
        @learning.save
      end
    else
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
    end
    flash[:notice] = "Profile updated"
    redirect_to root_path
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

  def new_lesson
    @lesson = Lesson.new
    @user = User.find(params[:id])
  end

  def landing
    if user_signed_in?
      redirect_to home_path
    end
  end


	private


	def set_user
		@user = User.find(params[:id])
	end


  def user_params
    params.require(:user).permit(:username, :description, :avatar, :sort, :direction, :search)
  end

  def sort_column
    Lesson.column_names.include?(params[:sort]) ? params[:sort] : "title"

  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
