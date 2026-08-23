class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.string :author
      t.timestamp :sent_at
      t.timestamp :edited_at

      t.timestamps
    end
  end
end
