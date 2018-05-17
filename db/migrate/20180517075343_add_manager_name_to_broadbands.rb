class AddManagerNameToBroadbands < ActiveRecord::Migration[5.1]
  def change
    add_column :broadbands, :manager_name, :string
    add_column :broadbands, :user_id, :string
  end
end
