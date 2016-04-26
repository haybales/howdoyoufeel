class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.integer :vote

      t.timestamps null: false
    end
  end
end
