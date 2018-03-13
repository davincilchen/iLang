class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :learnings, dependent: :destroy
  has_many :learning_languages, through: :learnings, source: :language

  has_many :teachings, dependent: :destroy
  has_many :teaching_languages, through: :teachings, source: :language
end
