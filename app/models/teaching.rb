class Teaching < ApplicationRecord
  belongs_to :user

  has_many :languages
end
