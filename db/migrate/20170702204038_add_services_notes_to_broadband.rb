class AddServicesNotesToBroadband < ActiveRecord::Migration[5.1]
  def change
    add_column :broadbands, :services, :string
    add_column :broadbands, :notes, :string
  end
end
