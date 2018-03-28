class LessonsController < ApplicationController
  
  def index

    @lessons = Lesson.where("teacher_id = ? or student_id = ?",current_user,current_user)
    @lessons.each do |lesson|
      if lesson.status == true
        @lesson = lesson
      end
    end

  end

  def new
    @lesson = Lesson.new
  end

  def create
    if current_user.is_ongoing_lesson?
      flash[:alert] = "There is an ongoing lesson, please finished it first!!"
      redirect_to lessons_path
    else
      unless params[:role].blank? || params[:friendship][:id].blank? || params[:language][:id].blank? 
        if params[:role] == "teacher"
          @lesson = current_user.teached_lessons.build(lesson_params)
          @lesson.student_id = params[:friendship][:id]
        else
          @lesson = current_user.learned_lessons.build(lesson_params)
          @lesson.teacher_id = params[:friendship][:id]     
        end
        @lesson.generate_random_pad
        @lesson.language_id = params[:language][:id]
        if @lesson.save
          redirect_to lesson_path(@lesson)
        else
          logger.debug "New error: #{@lesson.errors.full_messages.to_sentence}"
          flash[:alert] = @lesson.errors.full_messages.to_sentence
          redirect_to new_lesson_path
        end
      else
        flash[:alert] = "Please select all item"
        redirect_to new_lesson_path
      end
    end
  end


  def update_languages
    if params[:role] == ""
      @role = "false"
      respond_to do |format|
        format.js { flash.now[:alert] = "Please select your role" }
      end
    elsif params[:friendship_id] == ""
      @role = "true"
    else
      @user = User.find(params[:friendship_id])
      if params[:role] == "teacher"
        @languages = @user.teaching_languages
      else
        @languages = @user.learning_languages
      end      
      respond_to do |format|
        format.js
      end
    end
  end

  before_action :get_lesson, only: [:show, :update]

  def show
  end

  def update
    @lesson.status = "false"
    if @lesson.update(lesson_content_param)
      flash[:notice] = "lesson has completed"
      redirect_to root_path
    else
      flash[:alert] = @lesson.errors.full_messages.to_sentence
      render :action => :show
    end
  end

  private
  def get_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :teacher_id, :student_id, :language_id)
  end

  def lesson_content_param
    params.permit(:content)
  end
end
