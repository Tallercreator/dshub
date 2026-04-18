class CreateResources < ActiveRecord::Migration[8.0]
  def change
    create_table :resources do |t|
      t.string :resource_type
      t.string :tags
      t.string :title
      t.text :description
      t.string :url
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
