class VocabsController < ApplicationController
	def index
		@vocabs = nil
	end 

  before_action :get_lesson, only: [:show]
  def show 
    @vocabs = @lesson.vocabs
  end
  def search_vocabs
    @vocabs = Vocab.where("language_id = ? and student_id = ?", params[:language_id],current_user)    
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {vocabs: @vocabs}
        }
      end
    end
  end

  private
  def get_lesson
    @lesson = Lesson.find(params[:id])
  end
end
