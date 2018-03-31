class CreateVocabs < ActiveRecord::Migration[5.1]
  def change
    create_table :vocabs do |t|
      t.integer :language_id
      t.integer :student_id
      t.integer :lesson_id
      t.string :key
      t.string :value
      t.timestamps
    end
  end
end
