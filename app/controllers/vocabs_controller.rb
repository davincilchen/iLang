class VocabsController < ApplicationController
  def index
		@vocabs = current_user.vocabs
	end 
end
