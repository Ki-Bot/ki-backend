class AddBroadbandImages < ActiveRecord::Migration[5.1]
  def up
    add_attachment :broadbands, :banner
    add_attachment :broadbands, :logo
  end

  def down
    remove_attachment :broadbands, :banner
    remove_attachment :broadbands, :logo
  end
end
