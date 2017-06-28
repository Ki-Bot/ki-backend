class RemoveUserCredentialsRequired < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :email, :string, null: true
    change_column :users, :encrypted_password, :string, null: true

    remove_index :users, :email   #remove unique constraint
    remove_index :users, :reset_password_token    #remove unique constraint
    add_index :users, :email
    add_index :users, :reset_password_token
  end

  def down
    change_column :users, :email, :string, null: false, default: ""
    change_column :users, :encrypted_password, :string, null: false, default: ""
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
