class AddOriginImageIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :origin_image_id, :integer
  end
end
