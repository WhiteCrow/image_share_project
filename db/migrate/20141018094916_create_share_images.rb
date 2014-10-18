class CreateShareImages < ActiveRecord::Migration
  def change
    create_table :share_images do |t|
      t.integer :image_id
      t.integer :shared_user_id

      t.timestamps
    end
  end
end
