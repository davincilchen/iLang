class LessonsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @lessons = Lesson.includes(:user, :language).where(user_id: current_user).search(params[:search]).order(sort_column + " " + sort_direction)
    # @lessons = Lesson.includes(:user, :language).all

    # data = []
    # @lessons.each do |lesson|
    #   data.push(lesson.user.username)
    # end

    # render json: @lessons
  end

  def ui
    @lessons = Lesson.all

    draw = params[:draw]
    if draw == nil
      draw = 1
    else
      draw = Integer(draw) + 1
    end

    # TODO: start
    # TODO: length
    # TODO: search[value]
    # TODO: order

    data = Array.new # => []

    i = 0
    @lessons.each do |lesson|
      i += 1

      data.push([lesson.title])
      
      if i == 10 
        break
      end
    end

    

      ds = {
        "draw": draw,
        "recordsTotal": @lessons.count,
        "recordsFiltered": @lessons.count,
        "data": data
      }
      render json: ds
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

  def sort_column
    Lesson.column_names.include?(params[:sort]) ? params[:sort] : "title"

  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
