class Image < ActiveRecord::Base
  belongs_to :user
  has_many :share_images
  validates_presence_of :user_id, :version, :avatar

  default_scope { where(removed: false) }

  mount_uploader :avatar, AvatarUploader

  def shareable_users
    User.where.not(id: self.user_id)
  end

  def shared?(user_id)
    self.share_images.where(shared_user_id: user_id).present?
  end
end
