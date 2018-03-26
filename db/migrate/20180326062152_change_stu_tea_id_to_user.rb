class ChangeStuTeaIdToUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :lessons, :teacher_id, :integer
    rename_column :lessons, :student_id, :user_id
  end
end
