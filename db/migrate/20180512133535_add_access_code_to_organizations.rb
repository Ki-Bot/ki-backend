class AddAccessCodeToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :access_code, :string
  end
end
