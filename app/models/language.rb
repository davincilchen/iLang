class Language < ApplicationRecord
  has_many :teachings, dependent: :destroy
  has_many :teaching_users, through: :teachings, source: :user

  has_many :learnings, dependent: :destroy
  has_many :learning_users, through: :learnings, source: :user

  has_and_belongs_to_many :users

end
