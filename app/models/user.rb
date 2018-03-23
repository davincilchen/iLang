class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  validates_uniqueness_of :username
  validates_uniqueness_of :email



  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :learnings, dependent: :destroy
  has_many :learning_languages, through: :learnings, source: :language

  has_many :teachings, dependent: :destroy
  has_many :teaching_languages, through: :teachings, source: :language

  mount_uploader :avatar, AvatarUploader

  has_many :friendships, dependent: :destroy
  has_many :friendings, through: :friendships

  has_many :lessons, dependent: :destroy
  has_many :lessoning_languages, through: :lessons, source: :language

  def friending?(user)
    self.friendings.include?(user)
  end
  
end
