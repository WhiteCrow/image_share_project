class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :images
  has_many :share_images

  validates_presence_of :email, :name

  def was_shared_images
    ShareImage.includes(:image).where(shared_user_id: self.id).map(&:image)
  end
end
