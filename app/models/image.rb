class Image < ActiveRecord::Base

  belongs_to :user
  has_many :share_images, dependent: :destroy
  validates_presence_of :user_id, :version, :avatar
  validates_uniqueness_of :version, scope: :origin_image_id
  validates_numericality_of :version, greater_than_or_equal_to: 1, allow_nil: true

  default_scope { where(removed: false).order("origin_image_id") }

  mount_uploader :avatar, AvatarUploader

  def shareable_users
    User.where.not(id: self.user_id)
  end

  def shared?(user_id)
    self.share_images.where(shared_user_id: user_id).present?
  end

  def remove
    self.where_same_origin.each do |image|
      image.update!(removed: true)
    end
  end

  def unremove
    self.where_same_origin.each do |image|
      image.update!(removed: false)
    end
  end

  def full_destroy
    self.where_same_origin.each do |image|
      image.destroy
    end
  end

  def where_same_origin
    Image.unscoped.where(origin_image_id: self.origin_image_id)
  end

  def create_version(filter)
    Image.create!(version: last_version + 1,
                  user_id: user_id,
                  origin_image_id: origin_image_id,
                  avatar: File.open(avatar.public_send(filter).split(" ").first)
                 )
  end

  def last_version
    Image.where(origin_image_id: self.origin_image_id).map(&:version).max
  end

  def self.last_version
    self.select{|image| image.version == image.last_version}
  end
end
