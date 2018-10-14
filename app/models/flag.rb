class Flag < ApplicationRecord
  belongs_to :organization
  has_one :report
  has_many :external_users, dependent: :destroy, inverse_of: :flag
  accepts_nested_attributes_for :external_users
end
