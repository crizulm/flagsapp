class Flag < ApplicationRecord
  belongs_to :organization
  has_one :report
  has_many :external_users, dependent: :destroy, inverse_of: :flag
  accepts_nested_attributes_for :external_users, reject_if: proc { |att| att['user_id'].blank? }

  validates :name, presence: true
  validates :style_function, presence: true
end
