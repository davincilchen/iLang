class UsersDatatable < ApplicationDatatable

  private

  def count
    User.lessons.count
  end

end