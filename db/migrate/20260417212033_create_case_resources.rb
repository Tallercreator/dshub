class CreateCaseResources < ActiveRecord::Migration[8.0]
  def change
    create_table :case_resources do |t|
      t.references :case, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
