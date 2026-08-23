class AddStarredToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :starred, :boolean, default: false, null: false
  end
end
