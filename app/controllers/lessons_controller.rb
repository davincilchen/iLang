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
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      flash[:notice] = "lesson was successfully created"
      redirect_to root_path
    else
      flash.now[:alert] = "lesson was failed to create"
      render :new
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
    params.require(:lesson).permit(:title, :content)
  end
end
