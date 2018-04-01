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

  #mount_uploader :avatar, AvatarUploader

  has_many :friendships, dependent: :destroy
  has_many :friendings, through: :friendships

  has_many :teached_lessons, class_name: "Lesson", foreign_key: "teacher_id"
  has_many :learned_lessons, class_name: "Lesson", foreign_key: "student_id"

  has_many :vocabs, foreign_key: "student_id", dependent: :destroy

  def friending?(user)
    self.friendings.include?(user)
  end


  def is_ongoing_lesson?
    status = false
    @lessons = Lesson.where("teacher_id = ? or student_id = ?",self,self)
    @lessons.each do |lesson|
      if lesson.status == true
        status = true
      end
    end
    status
  end

end
