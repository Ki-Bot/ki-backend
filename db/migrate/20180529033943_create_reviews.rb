class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.belongs_to :user, index: true
      t.belongs_to :broadband, index: true
      t.string :comment

      t.timestamps
    end
  end
end
