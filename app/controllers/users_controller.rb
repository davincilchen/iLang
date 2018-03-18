class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def search
    if params["option"] == "Teach"
      # select all language
      if params[:language][:id] == ""
        @users = User.joins(:teaching_languages).group('users.id').having('count(user_id) > 0').order("random()")
      # select certain language
      else
        @users = User.joins(:teaching_languages).where("name = ?", params[:language][:id]).all.order("random()")
      end

    elsif params["option"] == "Learn"
      
      if params[:language][:id] == ""
        @users = User.joins(:learning_languages).group('users.id').having('count(user_id) > 0').order("random()")
      else
        @users = User.joins(:learning_languages).where("name = ?", params[:language][:id]).all.order("random()")
      end
    end     
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:username, :description, :avatar)
  end

end
