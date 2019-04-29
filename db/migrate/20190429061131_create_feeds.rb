class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.boolean :marked
      t.string :title
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
