class ChangeLessonPadIdName < ActiveRecord::Migration[5.1]
  def change
    rename_column :lessons, :padID, :pad_id
  end
end
