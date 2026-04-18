class CreateTermCases < ActiveRecord::Migration[8.0]
  def change
    create_table :term_cases do |t|
      t.references :term, null: false, foreign_key: true
      t.references :case, null: false, foreign_key: true
      t.timestamps
    end
    add_index :term_cases, [:term_id, :case_id], unique: true
  end
end
