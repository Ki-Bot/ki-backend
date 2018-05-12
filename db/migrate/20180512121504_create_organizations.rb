class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.string :manager_name
      t.string :phone_no
      t.string :address
      t.string :password
      t.string :user_id
      t.boolean :is_approved

      t.timestamps
    end
  end
end
