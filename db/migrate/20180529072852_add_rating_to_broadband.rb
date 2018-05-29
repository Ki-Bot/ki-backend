class AddRatingToBroadband < ActiveRecord::Migration[5.1]
  def change
    add_column :broadbands, :rating, :integer, default: 5
  end
end
