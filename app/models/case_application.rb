class CaseApplication < ApplicationRecord
  validates :name, presence: true
  validates :telegram, presence: true
  validates :company, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name telegram company other_contact created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
