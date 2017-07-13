class ChangeOpenToClosed < ActiveRecord::Migration[5.1]
  def change
    rename_column :opening_hours, :open, :closed
  end
end
