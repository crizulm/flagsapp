class Report < ApplicationRecord
  belongs_to :flag

  validates :total_time, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :total_request, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :true_answer, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :false_answer, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
