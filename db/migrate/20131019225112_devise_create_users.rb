class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :nickname
      t.string :uid
      t.string :name
      t.string :image
      t.text :credentials
      t.integer :friend_ids, :array => true, :limit => 8

      t.timestamps
    end
    
    add_index :users, :uid, :unique => true

    # add_index :users, :email,                :unique => true
    # add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end
end
