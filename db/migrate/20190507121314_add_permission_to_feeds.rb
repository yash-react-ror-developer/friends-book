class AddPermissionToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :permission, :string
  end
end
