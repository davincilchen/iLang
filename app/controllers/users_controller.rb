class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def search
    if params["option"] == "Teach"
      @users = User.joins(:teaching_languages).group('users.id').having('count(user_id) > 0')
    elsif params["option"] == "Learn"
      @users = User.joins(:learning_languages).group('users.id').having('count(user_id) > 0') 
    end
      
  end
end
