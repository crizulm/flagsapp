class ExternalUser < ApplicationRecord
  belongs_to :flag, foreign_key: :flag_id, optional: true

  validates :user_id, presence: true, allow_blank: false
end
