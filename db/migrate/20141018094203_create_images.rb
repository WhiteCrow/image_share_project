class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.integer :version
      t.boolean :removed, default: false

      t.timestamps
    end
  end
end
