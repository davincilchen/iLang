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
    if params[:role] == "teacher"
      @lesson = current_user.teached_lessons.build(lesson_params)
      @lesson.student_id = params[:friendship][:id]
    else
      @lesson = current_user.learned_lessons.build(lesson_params)
      @lesson.teacher_id = params[:friendship][:id]     
    end
    @lesson.language_id = params[:language][:id]
    if @lesson.save
      redirect_to lesson_path(@lesson)
    else
      flash[:alert] = @lesson.errors.full_messages.to_sentence
      redirect_to lesson_path(@lesson)
    end
  end


  before_action :get_lesson, only: [:show, :update]

  def show
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    redirect_to root_path
    flash[:alert] = "lesson was deleted"
  end

  private
  def get_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title)
  end
end
