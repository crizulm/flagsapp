class Flag < ApplicationRecord
  belongs_to :organization
  has_one :report
end
