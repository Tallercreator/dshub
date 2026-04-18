class AddCardTitleToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :card_title, :string
  end
end
