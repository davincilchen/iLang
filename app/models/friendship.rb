class Friendship < ApplicationRecord

  belongs_to :user
  belongs_to :friending, class_name: "User"

  validates :friending_id, uniqueness: { scope: :user_id }
end
