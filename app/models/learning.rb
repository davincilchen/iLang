class Learning < ApplicationRecord
	validates :language_id, uniqueness: { scope: :user_id}

	belongs_to :user
	belongs_to :language
end
