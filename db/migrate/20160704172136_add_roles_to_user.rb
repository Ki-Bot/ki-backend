class AddRolesToUser < ActiveRecord::Migration[5.1]

  def change
    add_column :users, :roles, :string, array: true, default: []
  end

end
