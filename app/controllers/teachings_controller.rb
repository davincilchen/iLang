class TeachingsController < ApplicationController

  def index
    @teachings = Teaching.all
  end

end
