class FlagRequest < ApplicationRecord
  belongs_to :flag
  validates :new_request, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :new_true_answer, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
