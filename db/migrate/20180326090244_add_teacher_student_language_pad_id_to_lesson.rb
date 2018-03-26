class AddTeacherStudentLanguagePadIdToLesson < ActiveRecord::Migration[5.1]
  def change
    add_reference :lessons, :teacher, index: true
    add_reference :lessons, :student, index: true
    add_reference :lessons, :language, index: true
    add_column :lessons, :padID, :string
  end
end
