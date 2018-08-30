class AddRatingToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :rating, :integer, default: 5
  end
end
