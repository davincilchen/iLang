class Learning < ApplicationRecord
	validates :language_id, uniqueness: { scope: :user_id}

	validates_uniqueness_of :student_id, scope: [:language_id, :key, :value]

	belongs_to :user
	belongs_to :language
end
