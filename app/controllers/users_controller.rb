class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def learning
  end

  def teaching
  end

end
