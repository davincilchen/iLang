class TeachingsController < ApplicationController
  
  def index
    @teaching = current_user.teachings.build(user_id: params[:user_id])
  end

end
