class Image < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :version, :avatar

  default_scope { where(removed: false) }

  mount_uploader :avatar, AvatarUploader
end
