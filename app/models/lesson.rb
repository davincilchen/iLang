class Lesson < ApplicationRecord

  validates_presence_of :title
  
  belongs_to :user
  belongs_to :language

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      all
    end
  end
 
end
