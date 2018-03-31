class Vocab < ApplicationRecord
	validates :language_id, :student_id, :key, :value, presence: true

  belongs_to :student, class_name: "User"
  belongs_to :language
	belongs_to :lesson
end
