class Lesson < ApplicationRecord
  validates_presence_of :title
  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"
  belongs_to :language
 
  def generate_random_pad
    self.padID = random_string
  end

  def random_string(length=10)
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    randomstring = ''
    length.times { randomstring << chars[rand(chars.size)] }
    randomstring
  end
end
