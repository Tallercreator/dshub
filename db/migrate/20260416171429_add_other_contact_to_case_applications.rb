class AddOtherContactToCaseApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :case_applications, :other_contact, :string
  end
end
