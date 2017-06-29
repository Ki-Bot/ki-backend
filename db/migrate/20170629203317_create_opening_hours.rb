class CreateOpeningHours < ActiveRecord::Migration[5.1]
  def change
    create_table :opening_hours do |t|
      t.references :broadband, foreign_key: true, index: true
      t.integer :day, null: false
      t.time :from
      t.time :to
      t.boolean :open, default: true

      t.timestamps
    end
  end
end
