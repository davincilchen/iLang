class Vocab < ApplicationRecord
	validates :langauge_id, :student_id, :key, :value, presence: true

	belongs_to :user
	belongs_to :language
	belongs_to :lesson
end
