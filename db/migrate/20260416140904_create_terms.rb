class CreateTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :terms do |t|
      t.string :term
      t.text :definition
      t.string :category
      t.string :sources
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
