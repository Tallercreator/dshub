class CreateCases < ActiveRecord::Migration[8.0]
  def change
    create_table :cases do |t|
      t.string :company
      t.string :ds_name
      t.string :tags
      t.string :accent_color
      t.text :tldr
      t.text :context
      t.text :positioning
      t.text :composition
      t.text :processes
      t.text :documentation
      t.text :design_code_sync
      t.text :quality
      t.text :scaling
      t.text :unique_practices
      t.text :conclusions
      t.text :quotes
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
