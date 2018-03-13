class AddForeignKey < ActiveRecord::Migration[5.1]
  def change
    add_column :learnings, :user_id, :integer
    add_column :learnings, :language_id, :integer

    add_column :teachings, :user_id, :integer
    add_column :teachings, :language_id, :integer

  end
end
