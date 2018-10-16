class Flag < ApplicationRecord
  belongs_to :organization
  has_one :report
  has_many :external_users, dependent: :destroy, inverse_of: :flag
  accepts_nested_attributes_for :external_users

  validates :name, presence: true
  validates :style_function, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
  validates_associated :external_users
  validate :percentage_validation

  def percentage_validation
    if style_function == 2
      if percentage.blank? || percentage < 1
        errors.add(:percentage, "percentage must be greater or equals to 1")
      end

      if !percentage.blank? && percentage > 100
        errors.add(:percentage, "percentage must be less or equals to 100")
      end
    end
  end
end
