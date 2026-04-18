class CreateCaseApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :case_applications do |t|
      t.string :name
      t.string :telegram
      t.string :company

      t.timestamps
    end
  end
end
