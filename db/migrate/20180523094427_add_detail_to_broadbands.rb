class AddDetailToBroadbands < ActiveRecord::Migration[5.1]
  def change
    add_column :broadbands, :detail, :string
  end
end
