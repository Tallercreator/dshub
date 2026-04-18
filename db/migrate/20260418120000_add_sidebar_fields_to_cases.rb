class AddSidebarFieldsToCases < ActiveRecord::Migration[8.0]
  def change
    change_table :cases do |t|
      t.text :focus_description
      t.text :speaker_role
      t.text :artifacts
      t.text :intro
    end
  end
end
