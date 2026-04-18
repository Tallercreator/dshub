class AddCaseFormatToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :case_format, :string
  end
end
