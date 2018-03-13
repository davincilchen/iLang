class CreateTeachings < ActiveRecord::Migration[5.1]
  def change
    create_table :teachings do |t|

      t.timestamps
    end
  end
end
