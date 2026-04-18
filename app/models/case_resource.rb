class CaseResource < ApplicationRecord
  belongs_to :case
  belongs_to :resource

  validates :case_id, uniqueness: { scope: :resource_id }
end
