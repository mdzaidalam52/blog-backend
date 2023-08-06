class ChangeLikesTypeInPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :likes, :string
  end
end
