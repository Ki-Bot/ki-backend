class CreateFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :faqs do |t|
      t.belongs_to :broadband, index: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
