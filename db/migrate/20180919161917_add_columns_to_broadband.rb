class AddColumnsToBroadband < ActiveRecord::Migration[5.1]
  def change
    add_column :broadbands, :access_code, :string
    add_column :broadbands, :email, :string
    add_column :broadbands, :phone_no, :string
    add_column :broadbands, :password, :string
    add_column :broadbands, :is_approved, :boolean
  end
end
