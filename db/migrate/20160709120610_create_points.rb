class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.belongs_to :broadband, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
