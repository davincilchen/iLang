class VocabsController < ApplicationController
	def index
		@vocabs = nil
	end 

  def search_vocabs
    @vocabs = Vocab.where("language_id = ?", params[:language_id])    
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {vocabs: @vocabs}
        }
      end
    end
  end
end
