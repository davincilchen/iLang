class Lesson < ApplicationRecord

  validates_presence_of :title

  belongs_to :teacher, class_name: "User"
  belongs_to :student, class_name: "User"
  belongs_to :language

  has_many :vocabs, dependent: :destroy
 
  def generate_random_pad
    self.pad_id = SecureRandom.hex(10)
  end

  def self.search(search)
    if search
      # where('title LIKE ?', "%#{search}%")
      where('title LIKE ? OR content LIKE ? ', "%#{search}%", "%#{search}%")
    else
      all
    end
  end

end
