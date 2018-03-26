class RenameUserIdToStudentId < ActiveRecord::Migration[5.1]
  def change
    rename_column :lessons, :user_id, :student_id
    add_column :lessons, :teacher_id, :integer
  end
end
