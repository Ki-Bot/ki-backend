class AddColumnsToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :streetname, :string
    add_column :organizations, :city, :string
    add_column :organizations, :state_code, :string
    add_column :organizations, :zip5, :string
    add_reference :organizations, :broadband_type, foreign_key: true, index: true
  end
end
