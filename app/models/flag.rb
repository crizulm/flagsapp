class Flag < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :organization
  has_one :flag_request
  has_many :flag_records
  has_many :external_users, dependent: :destroy, inverse_of: :flag
  has_many :evaluate_histories, dependent: :destroy, inverse_of: :flag
  accepts_nested_attributes_for :external_users
  has_secure_token :auth_token

  validates :name, presence: true
  validates :style_flag, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
  validates_associated :external_users
  validate :percentage_validation

  attr_accessor :report

  def percentage_validation
    evaluate_percentage_negative if style_flag == 2
    evaluate_percentage_positive if style_flag == 2
  end

  def evaluate_percentage_negative
    errors.add(:percentage, 'percentage must be greater or equals to 1') if percentage.blank? || percentage < 1
  end

  def evaluate_percentage_positive
    errors.add(:percentage, 'percentage must be less or equals to 100') if !percentage.blank? && percentage > 100
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end
end
