class Vocab < ApplicationRecord
	validates :language_id, :student_id, :key, :value, presence: true

	belongs_to :user, optional: true
	belongs_to :language
	belongs_to :lesson
end
