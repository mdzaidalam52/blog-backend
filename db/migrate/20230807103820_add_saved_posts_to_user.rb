class AddSavedPostsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :saved_posts, :text
  end
end
