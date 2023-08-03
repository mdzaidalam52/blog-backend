class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.integer :followed_user_ids, array: true, default: []
      t.integer :followed_by_user_ids, array: true, default: []
      
      t.timestamps
    end
  end
end
