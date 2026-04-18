class AddPurposeContextToTerms < ActiveRecord::Migration[8.0]
  def change
    add_column :terms, :purpose, :text
    add_column :terms, :context, :text
  end
end
