class ShareImage < ActiveRecord::Base
  belongs_to :shared_user, class_name: :User
  belongs_to :image

  validates_presence_of :image_id, :shared_user_id
  validates_uniqueness_of :image_id, scope: :shared_user_id

end
