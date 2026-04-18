class AddFiltersToCases < ActiveRecord::Migration[8.0]
  def change
    add_column :cases, :industry, :string
    add_column :cases, :case_type, :string
    add_column :cases, :company_type, :string
    add_column :cases, :materials, :string
  end
end
