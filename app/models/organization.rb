class Organization < ApplicationRecord
  has_many :flags
  has_many :user
end
