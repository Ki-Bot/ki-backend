class AddTypeToBroadband < ActiveRecord::Migration[5.1]
  def change
    add_reference :broadbands, :broadband_type, foreign_key: true, index: true
  end
end
