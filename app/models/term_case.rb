class TermCase < ApplicationRecord
  belongs_to :term
  belongs_to :case, class_name: "Case"
end
