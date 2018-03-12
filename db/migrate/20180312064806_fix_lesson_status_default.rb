class FixLessonStatusDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:lessons, :status, true)
  end
end
