class AddForeignKeyToLesson < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :user_id, :integer
    add_column :lessons, :language_id, :integer
  end
end
