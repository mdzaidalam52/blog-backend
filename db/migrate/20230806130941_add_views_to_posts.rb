class AddViewsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :views, :integer
  end
end
