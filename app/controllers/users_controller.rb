class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def search
    if params["option"] == "Teach"
      # select all language
      if params[:language][:id] == ""
        @users = User.joins(:teaching_languages).group('users.id').having('count(user_id) > 0')
      # select certain language
      else
        @users = User.joins(:teaching_languages).where("name = ?", params[:language][:id]).all
      end

    elsif params["option"] == "Learn"
      
      if params[:language][:id] == ""
        @users = User.joins(:learning_languages).group('users.id').having('count(user_id) > 0')
      else
        @users = User.joins(:learning_languages).where("name = ?", params[:language][:id]).all
      end
    end
      
  end
end
