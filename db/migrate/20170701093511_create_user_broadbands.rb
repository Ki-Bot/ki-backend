class CreateUserBroadbands < ActiveRecord::Migration[5.1]
  def change
    create_table :user_broadbands do |t|
      t.references :user, foreign_key: true, index: true
      t.references :broadband, foreign_key: true, index: true

      t.timestamps
    end
  end
end
