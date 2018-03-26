class Lesson < ApplicationRecord
  validates_presence_of :title
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"
  belongs_to :language
end
