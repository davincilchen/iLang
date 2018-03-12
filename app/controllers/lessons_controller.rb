class LessonsController < ApplicationController

  def index
    @lessons = Lesson.all
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

  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    redirect_to root_path
    flash[:alert] = "lesson was deleted"
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :content)
  end
end
